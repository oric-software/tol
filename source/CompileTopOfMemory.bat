@ECHO OFF
SET STARTADDR=$a000
SET INPUTFN=topofmemory
SET OUTTAP=toltop.tap
SET AUTOFLAG=0
c:\emulate\crosscompilers\osdk\bin\xa.exe %INPUTFN%.s -o final.out -e xaerr.txt -l %INPUTFN%.txt
c:\emulate\crosscompilers\osdk\bin\header.exe -a%AUTOFLAG% final.out %OUTTAP% %STARTADDR%
copy %OUTTAP% c:\emulate\oric\shared /Y
pause
