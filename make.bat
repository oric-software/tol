@ECHO OFF

echo Generating storybook ...
cd Storybook2
call Buildsb.bat
copy release\*.* ..\release
cd ..\



