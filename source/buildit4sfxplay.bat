@ECHO OFF
SET STARTADDR=$3000
SET INPUTFN=new_sfx
SET OUTTAP=sfxplay.tap
SET AUTOFLAG=0
c:\emulate\crosscompilers\osdk\bin\xa.exe %INPUTFN%.s -o final.out -e xaerr.txt -l %INPUTFN%.txt
c:\emulate\crosscompilers\osdk\bin\header.exe -a%AUTOFLAG% final.out %OUTTAP% %STARTADDR%
copy %OUTTAP% c:\emulate\oric\temp /Y


