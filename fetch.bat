@echo off
setlocal EnableDelayedExpansion 

echo Check latest version
xidel http://www.mozilla.org/en-US/firefox/new/ -e "//li[@class='os_windows']/a/@href" > tmp_firefox
set /p url_firefox=<tmp_firefox
wget --no-check-certificate "%url_firefox%" -O firefox.exe
del tmp_firefox
7za.exe e firefox.exe -y -ofirefox
for /f "tokens=3" %%v in ('sigcheck "firefox/firefox.exe"^|find /i "version"') do set fileVersion=%%v
echo %fileVersion%


REM xidel http://java.com/en/download/chrome.jsp?locale=en -e "//a[@class='jvdla0']/@href" > tmp_java
REM set /p url_java=<tmp_java
REM wget --no-check-certificate "%url_java%" -O java.exe
REM del tmp_java


REM wget --no-check-certificate https://tools.google.com/service/update2 --post-data "<?xml version='1.0' encoding='UTF-8'?><request protocol='3.0' version='1.3.21.135' shell_version='1.3.21.103' ismachine='1' sessionid='{8989B147-F32D-43EA-BB06-9901D388E712}' installsource='ondemandcheckforupdate' requestid='{4A6167C6-5DDA-435C-B306-D591CA20FB0D}'><os platform='win' version='6.1' sp='' arch='x86'/><app appid='{4DC8B4CA-1BDA-483E-B5FA-D3C12E15B62D}' version='0' nextversion='' ap='-multi-chrome' lang='' brand='GGLS' client=''><updatecheck/><ping active='1'/></app></request>" -O chrome.xml

REM REM tutorial about XMLStarlet http://dynamomd.org/index.php/tutorialA
REM xml sel -t -m "//manifest" -v "@version" chrome.xml
REM del chrome.xml

REM xidel http://windows.microsoft.com/en-us/windows/upgrade-your-browser -e "//span[@class='btnBase']/a/@href" > tmp_ie_xp
REM set /p url_ie_xp=<tmp_ie_xp
REM wget --no-check-certificate "%url_ie_xp%" -O ie_xp.exe
REM 7za.exe e ie_xp.exe -y -oie_xp


REM xidel http://www.microsoft.com/windows/ie/ --user-agent="Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.0; Trident/4.0)" -e "(//span[@class='btnBase']/a/@href)[1]" > tmp_ie_vista
REM set /p url_ie_vista=<tmp_ie_vista
REM wget --user-agent="Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.0; Trident/4.0)" "%url_ie_vista%" -O ie_vista.html
