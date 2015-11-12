@echo off


set today=%date%
date 2014/1/1

echo 日期已设置为2014年1月1日


echo 等待5分钟或按下任意键恢复真实日期

rem timeout /t 300
echo "after set" %date%

date %today%



set TODAY=%date%

rem echo  *** %TIME%  
echo now %TODAY%

set THISDATE=%DATE:~0,4%%DATE:~5,2%%DATE:~8,2%
set /a 
echo %THISDATE%
set /a OLDDATE=20140101
echo %OLDDATE%

IF "%THISDATE%" GTR "%OLDDATE%"
(echo %THISDATE% %OLDDATE% )
ELSE IF
(echo %THISDATE% %TODAY% )




set THISDATETIME=%DATE:~0,4%%DATE:~5,2%%DATE:~8,2%%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%  
echo  %THISDATETIME%  
  
