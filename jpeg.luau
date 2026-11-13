--!strict

export type JPEG = {
	width: number,
	height: number,
	pixels: buffer,
	readPixel: (x: number, y: number) -> (number, number, number, number),
}

export type DecodeOptions = {
	yieldIfNeeded: (() -> ())?,
}

type Component = {
	id: number,
	h: number,
	v: number,
	quantTable: number,
	dcTable: number,
	acTable: number,
	predictor: number,
	plane: buffer?,
	planeWidth: number,
	planeHeight: number,
}

type HuffmanTable = { [number]: { [number]: number } }

local ZIGZAG = {
	0, 1, 8, 16, 9, 2, 3, 10,
	17, 24, 32, 25, 18, 11, 4, 5,
	12, 19, 26, 33, 40, 48, 41, 34,
	27, 20, 13, 6, 7, 14, 21, 28,
	35, 42, 49, 56, 57, 50, 43, 36,
	29, 22, 15, 23, 30, 37, 44, 51,
	58, 59, 52, 45, 38, 31, 39, 46,
	53, 60, 61, 54, 47, 55, 62, 63,
}

local COSINE = table.create(8)
for frequency = 0, 7 do
	local row = table.create(8)
	for sample = 0, 7 do
		row[sample + 1] = math.cos((2 * sample + 1) * frequency * math.pi / 16)
	end
	COSINE[frequency + 1] = row
end

local SCALE = { 1 / math.sqrt(2), 1, 1, 1, 1, 1, 1, 1 }

local function readU16(buf: buffer, offset: number): number
	return buffer.readu8(buf, offset) * 256 + buffer.readu8(buf, offset + 1)
end

local function buildHuffmanTable(buf: buffer, offset: number, endOffset: number): (HuffmanTable, number)
	local counts = table.create(16)
	local symbolCount = 0
	for i = 1, 16 do
		assert(offset + i <= endOffset, "truncated JPEG Huffman table")
		local count = buffer.readu8(buf, offset + i - 1)
		counts[i] = count
		symbolCount += count
	end
	assert(symbolCount > 0 and symbolCount <= 256 and offset + 16 + symbolCount <= endOffset, "invalid JPEG Huffman table size")

	local symbols = table.create(symbolCount)
	for i = 1, symbolCount do
		symbols[i] = buffer.readu8(buf, offset + 16 + i - 1)
	end

	local tableByLength: HuffmanTable = {}
	local code = 0
	local symbolIndex = 1
	for length = 1, 16 do
		assert(code + counts[length] <= 2 ^ length, "oversubscribed JPEG Huffman table")
		local byCode = {}
		for _ = 1, counts[length] do
			byCode[code] = symbols[symbolIndex]
			symbolIndex += 1
			code += 1
		end
		tableByLength[length] = byCode
		code *= 2
	end

	return tableByLength, 16 + symbolCount
end

local function makeReader(buf: buffer, offset: number)
	local bitBuffer = 0
	local bitCount = 0
	local position = offset
	local length = buffer.len(buf)

	local function readEntropyByte(): number
		assert(position < length, "unexpected end of JPEG scan")
		local value = buffer.readu8(buf, position)
		position += 1
		if value == 0xFF then
			assert(position < length, "unexpected end after JPEG marker prefix")
			local nextByte = buffer.readu8(buf, position)
			position += 1
			assert(nextByte == 0, "unexpected marker inside JPEG scan")
		end
		return value
	end

	local function readBits(count: number): number
		if count == 0 then
			return 0
		end
		while bitCount < count do
			bitBuffer = bitBuffer * 256 + readEntropyByte()
			bitCount += 8
		end
		bitCount -= count
		local value = math.floor(bitBuffer / (2 ^ bitCount)) % (2 ^ count)
		bitBuffer %= 2 ^ bitCount
		return value
	end

	local function readHuffman(tableByLength: HuffmanTable): number
		local code = 0
		for lengthBits = 1, 16 do
			code = code * 2 + readBits(1)
			local symbol = tableByLength[lengthBits][code]
			if symbol ~= nil then
				return symbol
			end
		end
		error("invalid JPEG Huffman code")
	end

	local function readRestartMarker(expected: number)
		bitBuffer = 0
		bitCount = 0
		assert(position < length and buffer.readu8(buf, position) == 0xFF, "missing JPEG restart marker")
		while position < length and buffer.readu8(buf, position) == 0xFF do
			position += 1
		end
		assert(position < length, "unexpected end before JPEG restart marker")
		local marker = buffer.readu8(buf, position)
		position += 1
		assert(marker == 0xD0 + expected, "invalid JPEG restart marker sequence")
	end

	local function assertEndOfImage()
		bitBuffer = 0
		bitCount = 0
		while position < length do
			assert(buffer.readu8(buf, position) == 0xFF, "invalid marker after JPEG scan")
			while position < length and buffer.readu8(buf, position) == 0xFF do
				position += 1
			end
			assert(position < length, "unexpected end before JPEG end marker")
			local marker = buffer.readu8(buf, position)
			position += 1
			if marker == 0xD9 then
				return
			end
			assert(marker ~= 0xDA and marker ~= 0xD8 and not (marker >= 0xD0 and marker <= 0xD7), "unexpected JPEG scan marker")
			assert(position + 2 <= length, "unexpected end in JPEG segment")
			local segmentLength = readU16(buf, position)
			assert(segmentLength >= 2 and position + segmentLength <= length, "invalid JPEG segment length")
			position += segmentLength
		end
		error("missing JPEG end marker")
	end

	return readBits, readHuffman, readRestartMarker, assertEndOfImage
end

local function receiveExtend(readBits: (number) -> number, count: number): number
	if count == 0 then
		return 0
	end
	local value = readBits(count)
	local threshold = 2 ^ (count - 1)
	if value < threshold then
		return value - (2 ^ count - 1)
	end
	return value
end

local function decodeBlock(
	readBits: (number) -> number,
	readHuffman: (HuffmanTable) -> number,
	dcTable: HuffmanTable,
	acTable: HuffmanTable,
	quantization: { number },
	component: Component,
	blockX: number,
	blockY: number
)
	local coefficients = table.create(64, 0)
	local dcLength = readHuffman(dcTable)
	assert(dcLength <= 11, "invalid baseline JPEG DC category")
	component.predictor += receiveExtend(readBits, dcLength)
	coefficients[1] = component.predictor * quantization[1]

	local index = 1
	while index < 64 do
		local symbol = readHuffman(acTable)
		local run = bit32.rshift(symbol, 4)
		local valueLength = bit32.band(symbol, 0x0F)
		if valueLength == 0 then
			if run == 0 then
				break
			end
			assert(run == 15, "invalid JPEG AC coefficient run")
			index += 16
			assert(index <= 64, "JPEG AC coefficient run is out of range")
		else
			assert(valueLength <= 10, "invalid baseline JPEG AC category")
			index += run
			assert(index < 64, "JPEG AC coefficient is out of range")
			local naturalIndex = ZIGZAG[index + 1] + 1
			coefficients[naturalIndex] = receiveExtend(readBits, valueLength) * quantization[naturalIndex]
			index += 1
		end
	end

	local horizontal = table.create(64, 0)
	for verticalFrequency = 0, 7 do
		for sampleX = 0, 7 do
			local sum = 0
			for horizontalFrequency = 0, 7 do
				local coefficient = coefficients[verticalFrequency * 8 + horizontalFrequency + 1]
				sum += SCALE[horizontalFrequency + 1] * coefficient
					* COSINE[horizontalFrequency + 1][sampleX + 1]
			end
			horizontal[verticalFrequency * 8 + sampleX + 1] = sum
		end
	end

	local plane = component.plane :: buffer
	local blockOffset = blockY * 8 * component.planeWidth + blockX * 8
	for sampleY = 0, 7 do
		for sampleX = 0, 7 do
			local sum = 0
			for verticalFrequency = 0, 7 do
				sum += SCALE[verticalFrequency + 1]
					* horizontal[verticalFrequency * 8 + sampleX + 1]
					* COSINE[verticalFrequency + 1][sampleY + 1]
			end
			local sample = math.clamp(math.floor(sum * 0.25 + 128.5), 0, 255)
			buffer.writeu8(plane, blockOffset + sampleY * component.planeWidth + sampleX, sample)
		end
	end
end

local function decode(buf: buffer, options: DecodeOptions?): JPEG
	local length = buffer.len(buf)
	assert(length >= 4, "not a JPEG")
	assert(buffer.readu8(buf, 0) == 0xFF and buffer.readu8(buf, 1) == 0xD8, "not a JPEG")
	local yieldIfNeeded = if options then options.yieldIfNeeded else nil
	assert(yieldIfNeeded == nil or type(yieldIfNeeded) == "function", "yieldIfNeeded must be a function")

	local quantizationTables: { [number]: { number } } = {}
	local huffmanTables: { [number]: { [number]: HuffmanTable } } = {}
	local components: { Component } = {}
	local componentById: { [number]: Component } = {}
	local width = 0
	local height = 0
	local maxH = 0
	local maxV = 0
	local restartInterval = 0
	local adobeTransform: number? = nil
	local position = 2
	local scanOffset = 0

	while position < length do
		assert(buffer.readu8(buf, position) == 0xFF, "invalid JPEG marker alignment")
		while position < length and buffer.readu8(buf, position) == 0xFF do
			position += 1
		end
		assert(position < length, "unexpected end before JPEG marker")
		local marker = buffer.readu8(buf, position)
		position += 1

		if marker == 0xD9 then
			break
		elseif marker == 0xD8 or marker == 0x01 or (marker >= 0xD0 and marker <= 0xD7) then
			continue
		end

		assert(position + 2 <= length, "unexpected end in JPEG segment")
		local segmentLength = readU16(buf, position)
		assert(segmentLength >= 2 and position + segmentLength <= length, "invalid JPEG segment length")
		local dataOffset = position + 2
		local dataLength = segmentLength - 2
		local nextPosition = position + segmentLength

		if marker == 0xDB then
			local cursor = dataOffset
			while cursor < nextPosition do
				local info = buffer.readu8(buf, cursor)
				cursor += 1
				local precision = bit32.rshift(info, 4)
				local tableId = bit32.band(info, 0x0F)
				assert(precision == 0 or precision == 1, "unsupported JPEG quantization precision")
				assert(tableId <= 3, "invalid JPEG quantization table id")
				assert(cursor + 64 * (precision + 1) <= nextPosition, "truncated JPEG quantization table")
				local tableValues = table.create(64)
				for i = 1, 64 do
					local value = if precision == 0 then buffer.readu8(buf, cursor) else readU16(buf, cursor)
					cursor += precision + 1
					assert(value > 0, "invalid JPEG quantization value")
					tableValues[ZIGZAG[i] + 1] = value
				end
				quantizationTables[tableId] = tableValues
			end
		elseif marker == 0xC4 then
			local cursor = dataOffset
			while cursor < nextPosition do
				local info = buffer.readu8(buf, cursor)
				cursor += 1
				local tableClass = bit32.rshift(info, 4)
				local tableId = bit32.band(info, 0x0F)
				assert(tableClass <= 1 and tableId <= 3, "invalid JPEG Huffman table id")
				local tableByLength, bytesRead = buildHuffmanTable(buf, cursor, nextPosition)
				cursor += bytesRead
				assert(cursor <= nextPosition, "truncated JPEG Huffman table")
				local classTables = huffmanTables[tableClass]
				if not classTables then
					classTables = {}
					huffmanTables[tableClass] = classTables
				end
				classTables[tableId] = tableByLength
			end
		elseif marker == 0xC0 then
			assert(dataLength >= 6, "truncated JPEG frame header")
			assert(buffer.readu8(buf, dataOffset) == 8, "only 8-bit JPEG is supported")
			height = readU16(buf, dataOffset + 1)
			width = readU16(buf, dataOffset + 3)
			assert(width > 0 and height > 0, "invalid JPEG dimensions")
			assert(width <= 8192 and height <= 8192 and width * height <= 16777216, "JPEG dimensions exceed supported limits")
			local componentCount = buffer.readu8(buf, dataOffset + 5)
			assert(componentCount == 1 or componentCount == 3, "only grayscale and three-component JPEG are supported")
			assert(dataLength == 6 + componentCount * 3, "invalid JPEG frame header length")
			for i = 1, componentCount do
				local componentOffset = dataOffset + 6 + (i - 1) * 3
				local id = buffer.readu8(buf, componentOffset)
				local sampling = buffer.readu8(buf, componentOffset + 1)
				local h = bit32.rshift(sampling, 4)
				local v = bit32.band(sampling, 0x0F)
				local quantTable = buffer.readu8(buf, componentOffset + 2)
				assert(h >= 1 and h <= 4 and v >= 1 and v <= 4, "invalid JPEG sampling factor")
				assert(quantTable <= 3 and componentById[id] == nil, "invalid JPEG frame component")
				local component: Component = {
					id = id,
					h = h,
					v = v,
					quantTable = quantTable,
					dcTable = 0,
					acTable = 0,
					predictor = 0,
					planeWidth = 0,
					planeHeight = 0,
				}
				table.insert(components, component)
				componentById[id] = component
				maxH = math.max(maxH, h)
				maxV = math.max(maxV, v)
			end
			for _, component in components do
				assert(component.h * component.v <= 10, "invalid JPEG MCU sampling factors")
			end
		elseif marker == 0xDD then
			assert(dataLength == 2, "invalid JPEG restart interval")
			restartInterval = readU16(buf, dataOffset)
		elseif marker == 0xEE and dataLength >= 12 and buffer.readstring(buf, dataOffset, 5) == "Adobe" then
			adobeTransform = buffer.readu8(buf, dataOffset + 11)
		elseif marker == 0xC2 then
			error("progressive JPEG is not supported")
		elseif marker == 0xDA then
			assert(#components > 0, "JPEG scan appears before frame header")
			assert(dataLength >= 4, "truncated JPEG scan header")
			local scanComponentCount = buffer.readu8(buf, dataOffset)
			assert(scanComponentCount == #components, "separate-component JPEG scans are not supported")
			assert(dataLength == 1 + scanComponentCount * 2 + 3, "invalid JPEG scan header length")
			local scanComponents = {}
			local scanComponentCountSeen = 0
			for i = 1, scanComponentCount do
				local scanComponentOffset = dataOffset + 1 + (i - 1) * 2
				local componentId = buffer.readu8(buf, scanComponentOffset)
				local component = componentById[componentId]
				assert(component ~= nil, "unknown JPEG scan component")
				assert(not scanComponents[componentId], "duplicate JPEG scan component")
				scanComponents[componentId] = true
				scanComponentCountSeen += 1
				local selectors = buffer.readu8(buf, scanComponentOffset + 1)
				component.dcTable = bit32.rshift(selectors, 4)
				component.acTable = bit32.band(selectors, 0x0F)
				assert(component.dcTable <= 3 and component.acTable <= 3, "invalid JPEG scan table selector")
			end
			assert(scanComponentCountSeen == #components, "JPEG scan is missing a frame component")
			local spectralOffset = dataOffset + 1 + scanComponentCount * 2
			assert(
				buffer.readu8(buf, spectralOffset) == 0
					and buffer.readu8(buf, spectralOffset + 1) == 63
					and buffer.readu8(buf, spectralOffset + 2) == 0,
				"only baseline sequential JPEG scans are supported"
			)
			scanOffset = nextPosition
			position = nextPosition
			break
		elseif marker >= 0xC1 and marker <= 0xCF and marker ~= 0xC4 and marker ~= 0xC8 and marker ~= 0xCC then
			error("unsupported JPEG frame encoding")
		end

		position = nextPosition
	end

	assert(scanOffset > 0, "JPEG scan was not found")
	local mcusWide = math.ceil(width / (maxH * 8))
	local mcusHigh = math.ceil(height / (maxV * 8))
	for _, component in components do
		component.planeWidth = mcusWide * component.h * 8
		component.planeHeight = mcusHigh * component.v * 8
		component.plane = buffer.create(component.planeWidth * component.planeHeight)
		assert(quantizationTables[component.quantTable] ~= nil, "missing JPEG quantization table")
	end

	local huffmanByClass = huffmanTables
	local readBits, readHuffman, readRestartMarker, assertEndOfImage = makeReader(buf, scanOffset)
	local mcuIndex = 0
	local restartIndex = 0
	for mcuY = 0, mcusHigh - 1 do
		for mcuX = 0, mcusWide - 1 do
			if restartInterval > 0 and mcuIndex > 0 and mcuIndex % restartInterval == 0 then
				readRestartMarker(restartIndex)
				restartIndex = (restartIndex + 1) % 8
				for _, component in components do
					component.predictor = 0
				end
			end

			for _, component in components do
				local dcTable = huffmanByClass[0] and huffmanByClass[0][component.dcTable]
				local acTable = huffmanByClass[1] and huffmanByClass[1][component.acTable]
				assert(dcTable ~= nil and acTable ~= nil, "missing JPEG Huffman table")
				local quantization = quantizationTables[component.quantTable]
				assert(quantization ~= nil, "missing JPEG quantization table")
				for blockY = 0, component.v - 1 do
					for blockX = 0, component.h - 1 do
						decodeBlock(
							readBits,
							readHuffman,
							dcTable,
							acTable,
							quantization,
							component,
							mcuX * component.h + blockX,
							mcuY * component.v + blockY
						)
					end
				end
			end

			mcuIndex += 1
			if yieldIfNeeded and mcuIndex % 8 == 0 then
				yieldIfNeeded()
			end
		end
	end
	assertEndOfImage()

	local pixels = buffer.create(width * height * 4)
	local isRgb = #components == 3
		and (adobeTransform == 0
			or (components[1].id == 82 and components[2].id == 71 and components[3].id == 66))
	for y = 0, height - 1 do
		for x = 0, width - 1 do
			local first = 0
			local second = 0
			local third = 0
			for i, component in components do
				local sampleX = math.floor(x * component.h / maxH)
				local sampleY = math.floor(y * component.v / maxV)
				local plane = component.plane :: buffer
				local sample = buffer.readu8(plane, sampleY * component.planeWidth + sampleX)
				if i == 1 then
					first = sample
				elseif i == 2 then
					second = sample
				else
					third = sample
				end
			end

			local red, green, blue
			if #components == 1 then
				red, green, blue = first, first, first
			elseif isRgb then
				red, green, blue = first, second, third
			else
				local chromaBlue = second - 128
				local chromaRed = third - 128
				red = math.clamp(math.floor(first + 1.402 * chromaRed + 0.5), 0, 255)
				green = math.clamp(math.floor(first - 0.344136 * chromaBlue - 0.714136 * chromaRed + 0.5), 0, 255)
				blue = math.clamp(math.floor(first + 1.772 * chromaBlue + 0.5), 0, 255)
			end

			local pixelOffset = (y * width + x) * 4
			buffer.writeu8(pixels, pixelOffset, red)
			buffer.writeu8(pixels, pixelOffset + 1, green)
			buffer.writeu8(pixels, pixelOffset + 2, blue)
			buffer.writeu8(pixels, pixelOffset + 3, 255)
		end
		if yieldIfNeeded then
			yieldIfNeeded()
		end
	end

	local function readPixel(x: number, y: number)
		assert(x >= 1 and x <= width and y >= 1 and y <= height, "pixel out of range")
		local offset = ((y - 1) * width + x - 1) * 4
		return buffer.readu8(pixels, offset),
			buffer.readu8(pixels, offset + 1),
			buffer.readu8(pixels, offset + 2),
			buffer.readu8(pixels, offset + 3)
	end

	return {
		width = width,
		height = height,
		pixels = pixels,
		readPixel = readPixel,
	}
end

local JPEG = {
	decode = decode,
	supportsYieldIfNeeded = true,
}

if typeof(script) == "Instance" and script:IsA("ModuleScript") then
	return JPEG
end
