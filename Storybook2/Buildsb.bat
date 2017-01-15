@ECHO OFF
SET STARTADDR=$500
SET INPUTFN=Driver
SET OUTTAP=sb.tap
SET AUTOFLAG=1

echo Building telemon Version (no header)
%osdk%\bin\xa.exe %INPUTFN%.s -o release\telemon.out -e xaerr.txt -l %INPUTFN%.txt -DTARGET_TELEMON

echo Building telemon Version for Orix
%osdk%\bin\xa.exe %INPUTFN%.s -o release\tolsb -e xaerr.txt -l %INPUTFN%.txt -DTARGET_TELEMON -DTARGET_ORIX 

echo Building atmos Version (no header)
%osdk%\bin\xa.exe %INPUTFN%.s -o release\final.out -e xaerr.txt -l %INPUTFN%.txt
%osdk%\bin\header.exe -a%AUTOFLAG% release\final.out release\%OUTTAP% %STARTADDR% 
rem copy %OUTTAP% c:\emulate\oric\oriculator\tapes /Y

