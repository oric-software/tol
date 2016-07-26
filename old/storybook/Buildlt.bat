@ECHO OFF
SET STARTADDR=$5000
SET INPUTFN=LoadText
SET OUTTAP=lt.tap
SET AUTOFLAG=0
c:\osdk\bin\xa.exe %INPUTFN%.s -o final.out -e xaerr.txt -l %INPUTFN%.txt
c:\osdk\bin\header.exe -a%AUTOFLAG% final.out %OUTTAP% %STARTADDR%
copy %OUTTAP% c:\emulate\oric\shared /Y
pause
