Aseprite Build
==============

Build script for simplifying building Aseprite on Windows.

## Tool dependencies
* Visual Studio 2022 (any edition) w/ Desktop C++ build tools
* CMake
* Ninja

## Instructions

1. Install dependencies listed above if not already installed (I use [scoop](https://scoop.sh/) for CMake and Ninja)
2. Download the latest *Skia-Windows-Release-x64.zip* from [here](https://github.com/aseprite/skia/releases)
3. Download Aseprite source code from [here](https://github.com/aseprite/aseprite/releases) or by checking out the repository
4. Extract *Skia-Windows-Release-x64.zip* into *deps/skia* under this repository
5. Extract (or copy) the Aseprite source code into *src* under this repository
6. Run `.\build.ps1` in a PowerShell Core terminal