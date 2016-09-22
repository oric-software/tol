@ECHO OFF
SET STARTADDR=$500
SET INPUTFN=Driver
SET OUTTAP=sb.tap
SET AUTOFLAG=1

echo Building telemon Version
%osdk%\bin\xa.exe %INPUTFN%.s -o telemon.out -e xaerr.txt -l %INPUTFN%.txt -DTARGET_TELEMON 

%osdk%\bin\xa.exe %INPUTFN%.s -o final.out -e xaerr.txt -l %INPUTFN%.txt
%osdk%\bin\header.exe -a%AUTOFLAG% final.out %OUTTAP% %STARTADDR% 
rem copy %OUTTAP% c:\emulate\oric\oriculator\tapes /Y
pause
