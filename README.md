# Walkthrough: Building LaTeX with Docker

I have configured your environment to use `miktex/miktex:essential` via Docker to build your LaTeX documents.

## Changes Made

### VS Code Integration
- Created [.vscode/settings.json](file:///d:/Self/HUST/CSGPANM/IEEE-conference-template-062824/.vscode/settings.json) to add a new build recipe: **"Docker MiKTeX (pdflatex)"**.
- This recipe runs `pdflatex` inside a MiKTeX Docker container and automatically maps your current directory to `/workdir`.

### Manual Build Script
- Created [build_with_docker.ps1](file:///d:/Self/HUST/CSGPANM/IEEE-conference-template-062824/build_with_docker.ps1) for building from the PowerShell terminal.
- This script pulls the image if it's missing and runs the build.

## How to Build

### Option 1: Using VS Code (Recommended)
1. Open `IEEE-conference-template-062824.tex`.
2. Click the **LaTeX Workshop icon** in the sidebar.
3. Under "Build LaTeX project", select **"Docker MiKTeX (pdflatex)"**.
4. The first build **will take several minutes** as MiKTeX needs to download required packages (like `IEEEtran`, `cite`, `amsmath`) from its server.

### Option 2: Using Terminal
Run the following command in your terminal:
```powershell
.\build_with_docker.ps1
```

## Important Notes
> [!IMPORTANT]
> The first run is slow because MiKTeX downloads packages on demand. Subsequent builds will be much faster.

> [!TIP]
> I have pointed the build to `IEEE-conference-template-062824.tex` as requested, and verified that it correctly uses `fig1.png`.
