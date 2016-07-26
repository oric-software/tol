@ECHO OFF

SET OSDKB="..\..\..\..\osdk\bin\"
SET ORICUTRON="..\..\..\..\oricutron\"


SET STARTADDR=$1000
SET INPUTFN=Driver
SET OUTTAP=sb.tap
SET AUTOFLAG=1
SET OSDKNAME=SB

SET ORIGIN_PATH=%CD%



rem TARGET ATMOS
%OSDKB%\xa.exe %INPUTFN%.s -o final.out -e xaerr.txt -l %INPUTFN%.txt





%OSDKB%\header.exe -a%AUTOFLAG% final.out %OUTTAP% %STARTADDR%

copy %OUTTAP% %ORICUTRON%\tapes

cd %ORICUTRON%

oricutron.exe --tape tapes\%OUTTAP%

cd %ORIGIN_PATH%

rem ########################################################
rem telemon version 
rem ########################################################
cd %ORIGIN_PATH%
rem TARGET TELEMON24
%OSDKB%\xa.exe %INPUTFN%.s -o final_telemon24.out -DTARGET_TELEMON24=YES  -e xaerr.txt -l %INPUTFN%.txt


%OSDKB%\header.exe -a1 final_telemon24.out SB24.TAP %STARTADDR%

%OSDKB%\tap2dsk.exe  SB24.tap TOL.dsk
%OSDKB%\old2mfm.exe TOL.dsk


copy TOL.dsk %ORICUTRON%\teledisks
cd %ORICUTRON%\

oricutron -mt -d teledisks\stratsed.dsk 
cd %ORIGIN_PATH%