@ECHO OFF
SET STARTADDR=$500
SET INPUTFN=sfx_editor
SET OUTTAP=sfxed.tap
SET AUTOFLAG=1
c:\emulate\crosscompilers\osdk\bin\xa.exe %INPUTFN%.s -o final.out -e xaerr.txt -l %INPUTFN%.txt
c:\emulate\crosscompilers\osdk\bin\header.exe -a%AUTOFLAG% final.out %OUTTAP% %STARTADDR%
copy %OUTTAP% c:\emulate\oric\system2 /Y
cd c:\emulate\oric\system2
euphoric.exe tol.dsk alleds.dsk
