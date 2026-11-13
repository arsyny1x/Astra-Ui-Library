local Players = game:GetService("Players")
local AssetService = game:GetService("AssetService")
local decoder = JPEG
local jpegModule = script and script.Parent and script.Parent:FindFirstChild("jpeg")
assert(type(decoder) == "table" and type(decoder.decode) == "function", "Run this after the JPEG decoder source or place it beside a ModuleScript named 'jpeg'")

local JPEG_URL = "https://images.alphacoders.com/131/thumb-1920-1311951.jpg" -- Replace with a direct JPEG URL.

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JpegDecoderTest"
screenGui.ResetOnSpawn = false
screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

local panel = Instance.new("Frame")
panel.AnchorPoint = Vector2.new(0.5, 0.5)
panel.Position = UDim2.fromScale(0.5, 0.5)
panel.Size = UDim2.fromOffset(420, 320)
panel.BackgroundColor3 = Color3.fromRGB(24, 27, 35)
panel.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = panel

local closeButton = Instance.new("TextButton")
closeButton.AnchorPoint = Vector2.new(1, 0)
closeButton.Position = UDim2.new(1, -8, 0, 8)
closeButton.Size = UDim2.fromOffset(52, 30)
closeButton.Text = "ปิด"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.BackgroundColor3 = Color3.fromRGB(190, 55, 65)
closeButton.Parent = panel

local imageLabel = Instance.new("ImageLabel")
imageLabel.Position = UDim2.fromOffset(12, 48)
imageLabel.Size = UDim2.new(1, -24, 1, -60)
imageLabel.BackgroundTransparency = 1
imageLabel.ScaleType = Enum.ScaleType.Fit
imageLabel.Parent = panel

local editableImage
closeButton.Activated:Connect(function()
	if editableImage then
		editableImage:Destroy()
	end
	screenGui:Destroy()
end)

local lastYield = os.clock()
local function yieldIfNeeded()
	if os.clock() - lastYield >= 1 / 60 then
		lastYield = os.clock()
		task.wait()
	end
end

task.spawn(function()
	local success, message = pcall(function()
		local encoded = buffer.fromstring(game:HttpGet(JPEG_URL))
		local decoded = decoder.decode(encoded, {
			yieldIfNeeded = yieldIfNeeded,
		})

		local maxImageSize = 1023
		local scale = math.min(1, maxImageSize / decoded.width, maxImageSize / decoded.height)
		local outputWidth = math.max(1, math.floor(decoded.width * scale))
		local outputHeight = math.max(1, math.floor(decoded.height * scale))
		local outputPixels = decoded.pixels

		if outputWidth ~= decoded.width or outputHeight ~= decoded.height then
			outputPixels = buffer.create(outputWidth * outputHeight * 4)
			for y = 0, outputHeight - 1 do
				local sourceY = math.floor(y * decoded.height / outputHeight)
				for x = 0, outputWidth - 1 do
					local sourceX = math.floor(x * decoded.width / outputWidth)
					local sourceOffset = (sourceY * decoded.width + sourceX) * 4
					local outputOffset = (y * outputWidth + x) * 4
					buffer.writeu32(outputPixels, outputOffset, buffer.readu32(decoded.pixels, sourceOffset))
				end
				yieldIfNeeded()
			end
		end

		editableImage = AssetService:CreateEditableImage({
			Size = Vector2.new(outputWidth, outputHeight),
		})
		assert(editableImage, "EditableImage creation is unavailable")
		editableImage:WritePixelsBuffer(Vector2.zero, Vector2.new(outputWidth, outputHeight), outputPixels)

		if screenGui.Parent then
			imageLabel.ImageContent = Content.fromObject(editableImage)
		else
			editableImage:Destroy()
			editableImage = nil
		end
	end)

	if not success then
		warn("[JPEG test] " .. tostring(message))
	end
end)
