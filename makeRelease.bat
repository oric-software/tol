@echo off

REM makeReleaseVersion : V0.0.3
REM Copy from man

SET BINARY=tol

Set VERSION=1.0.0

set PATH_TAR="C:\Program Files (x86)\GnuWin32\bin"
set PATH_UNZIP="C:\Program Files\7-Zip"

cd build
rem here clean it
del /S /F /Q %BINARY%.tar
cd ..

mkdir release\download\orix\%VERSION%\
mkdir build\usr\share\man
copy src\man\%BINARY%.hlp build\usr\share\man
xcopy README.md build\usr\share\doc\%BINARY%  /E /Q /Y
xcopy src\ipkg\* build\usr\share\ipkg  /E /Q /Y


cd build

%PATH_TAR%\tar -cf %BINARY%.tar *

cd ..

del /S /F /Q release\download\orix\%VERSION%\*.*
rmdir /s /q release\download\orix\%VERSION%\usr
copy build\%BINARY%.tar release\download\orix\%VERSION%\
%PATH_UNZIP%\7z a release\download\orix\%VERSION%\%BINARY%.tgz release\download\orix\%VERSION%\%BINARY%.tar
del /S /F /Q release\download\orix\%VERSION%\%BINARY%.tar


