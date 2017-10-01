@ECHO OFF
SET STARTADDR=$500
SET INPUTFN=Driver
SET OUTTAP=sb.tap
SET AUTOFLAG=1


rem #include "fonte.h"
rem #include "DisplayText.s"
rem #include "StorybookText.s"

rem #include "pacKnight.s"
rem #include "pacSelect9.s"
rem #include "pacStory1.s"
rem #include "pacStory2.s"
rem #include "pacStory32.s"
rem #include "pacStory4.s"
rem #include "pacStory5.s"
rem #include "pacStory6.s"
rem #include "pacStory7.s"
rem #include "pacValkyrie.s"
rem #include "pacWarrior.s"


IF NOT EXIST build\usr\share\ mkdir  build\usr\share\
IF NOT EXIST build\usr\share\tol\ mkdir  build\usr\share\tol\


%osdk%\bin\xa.exe pacStory1.s -o build\usr\share\tol\pcstory1.dat
%osdk%\bin\xa.exe pacStory2.s -o  build\usr\share\tol\pcstory2.dat
%osdk%\bin\xa.exe pacStory32.s -o  build\usr\share\tol\pcstory3.dat
%osdk%\bin\xa.exe pacStory4.s -o  build\usr\share\tol\pcstory4.dat
%osdk%\bin\xa.exe pacStory5.s -o  build\usr\share\tol\pcstory5.dat
%osdk%\bin\xa.exe pacStory6.s -o  build\usr\share\tol\pcstory6.dat
%osdk%\bin\xa.exe pacStory7.s -o  build\usr\share\tol\pcstory7.dat

echo Building telemon Version (no header)
%osdk%\bin\xa.exe %INPUTFN%.s -o release\telemon.out -e xaerr.txt -l %INPUTFN%.txt -DTARGET_TELEMON

echo Building telemon Version for Orix
mkdir build\usr\bin
%osdk%\bin\xa.exe %INPUTFN%.s -o build\usr\bin\tol -e xaerr.txt -l %INPUTFN%.txt -DTARGET_TELEMON -DTARGET_ORIX 

echo Building atmos Version 
%osdk%\bin\xa.exe %INPUTFN%.s -o release\final.out -e xaerr.txt -l %INPUTFN%.txt
%osdk%\bin\header.exe -a%AUTOFLAG% release\final.out release\%OUTTAP% %STARTADDR% 
rem copy %OUTTAP% c:\emulate\oric\oriculator\tapes /Y

