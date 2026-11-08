@echo off
setlocal

set "VCPKG_ROOT=%USERPROFILE%\vcpkg"
set "VCPKG_DEFAULT_TRIPLET=x64-windows-static-md"
set "UNASTAR_BDS_DIR=%USERPROFILE%\Downloads\bedrock-server-1.26.51.1"
set "UNASTAR_CONFIG=%~dp0server-config.toml"

if not exist "%VCPKG_ROOT%\vcpkg.exe" (
    echo vcpkg was not found at "%VCPKG_ROOT%".
    echo Install vcpkg and the zlib and snappy packages before starting the server.
    pause
    exit /b 1
)

if not exist "%UNASTAR_BDS_DIR%\bedrock_server.exe" (
    echo Bedrock Dedicated Server 1.26.51.1 files were not found in:
    echo "%UNASTAR_BDS_DIR%"
    echo.
    echo Download the 1.26.51.1 Windows server from:
    echo https://www.minecraft.net/bedrockdedicatedserver/bin-win/bedrock-server-1.26.51.1.zip
    echo Extract the archive into that folder. It must contain bedrock_server.exe,
    echo definitions, and the vanilla behavior packs.
    echo Do not use the current 1.26.63.1 release; this build needs version 1.26.51.1.
    pause
    exit /b 1
)

if not exist "%~dp0server-config.toml" (
    echo Server configuration "%~dp0server-config.toml" was not found.
    pause
    exit /b 1
)

echo Building/checking Unastar with Bedrock world generation...
cargo build --release -p unastar --features bedrock-worldgen --manifest-path "%~dp0Cargo.toml"
if errorlevel 1 (
    echo.
    echo The build failed. Review the error above.
    pause
    exit /b 1
)

if not exist "%~dp0server-data-bedrock" (
    mkdir "%~dp0server-data-bedrock"
    if errorlevel 1 (
        echo Could not create the server data directory.
        pause
        exit /b 1
    )
)

cd /d "%~dp0server-data-bedrock"
if errorlevel 1 (
    echo Could not open the server data directory.
    pause
    exit /b 1
)

"%~dp0target\release\unastar.exe"

echo.
echo The server process has ended.
pause
