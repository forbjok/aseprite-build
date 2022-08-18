@echo off
setlocal

rem Activate developer console
call "%VSDEVCMD_PATH%" -arch=x64

rem Generate makefile
cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo -DLAF_BACKEND=skia -DSKIA_DIR=%SKIA_DIR% -DSKIA_LIBRARY_DIR=%SKIA_DIR%\out\Release-x64 -DSKIA_LIBRARY=%SKIA_DIR%\out\Release-x64\skia.lib -G Ninja ..

rem Build Aseprite
ninja aseprite

endlocal