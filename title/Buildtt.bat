@ECHO OFF
SET STARTADDR=$500
SET INPUTFN=Driver
SET OUTTAP=tt.tap
SET AUTOFLAG=1
%osdk%\bin\xa.exe %INPUTFN%.s -o release\final.out -e xaerr.txt -l %INPUTFN%.txt
%osdk%\bin\header.exe -a%AUTOFLAG% release\final.out release\%OUTTAP% %STARTADDR%
rem copy %OUTTAP% c:\emulate\oric\shared /Y
rem pause
