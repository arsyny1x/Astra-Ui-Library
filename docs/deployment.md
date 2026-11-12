# Publish with GitHub Pages

The documentation site is static and lives in the repository root. It uses Docsify from a CDN, so there is no local build step.

1. Push the project to a GitHub repository. The repository must include `index.html`, `README.md`, `_sidebar.md`, `.nojekyll`, and the `docs/` directory.
2. Open the repository on GitHub and go to **Settings → Pages**.
3. Under **Build and deployment**, choose **Deploy from a branch**.
4. Select the branch you publish from (usually `main`) and the `/(root)` folder, then save.
5. Wait for the Pages deployment to finish. GitHub displays the published URL in the Pages settings.

The Docsify shell uses relative paths, so it works both at a project URL such as `https://username.github.io/repository/` and at a user-site root. Changes become public only after the repository is pushed and Pages is enabled. No deployment or publication is performed by these local files.

If GitHub Pages reports a 404, verify that `index.html` is in the selected publishing folder and that the deployment job completed successfully.
