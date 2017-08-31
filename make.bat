@ECHO OFF



SET BINARYFILE=tol
SET PATH_RELEASE=build\usr\share\%BINARYFILE%\
SET ORICUTRON="..\..\..\oricutron\"
set VERSION=1.0.0
SET ORIGIN_PATH=%CD%
echo %osdk%
SET PATH=%PATH%;%CC65%



mkdir build\usr\share\doc\
mkdir build\usr\share\doc\%BINARYFILE%
mkdir build\usr\share\man
mkdir build\usr\bin\

IF NOT EXIST build\usr\share\ipkg mkdir build\usr\share\ipkg      

echo Building version.h
echo #define VERSION "%VERSION%" > src\version.h
rem  123456789012345678
echo Building ipkg csv
echo tol       1.0.0  Times of lore Storybook > src\ipkg\%BINARYFILE%.csv
echo Copy README.md
copy README.md build\usr\share\doc\%BINARYFILE%
copy src\ipkg\%BINARYFILE%.csv build\usr\share\ipkg 
copy src\man\%BINARYFILE%.hlp build\usr\share\man\

echo Generating storybook ...
cd Storybook2
call Buildsb.bat
copy release\*.* ..\release
rem mkdir build

cd ..\
mkdir build\usr\bin\
copy Storybook2\build\usr\bin\tol build\usr\bin\tol




rem cl65 -orelease\usr\bin\ch376 -ttelestrat ch376.c ..\oric-common\lib\ca65\ch376.s



IF "%1"=="NORUN" GOTO End

copy build\usr\bin\tol %ORICUTRON%\usbdrive\usr\bin\
echo test
copy src\man\%BINARYFILE%.hlp %ORICUTRON%\usbdrive\usr\share\man\

cd %ORICUTRON%
OricutronV4 -mt

cd %ORIGIN_PATH%
:End



