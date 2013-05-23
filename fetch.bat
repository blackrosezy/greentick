@echo off
setlocal EnableDelayedExpansion 

rm -rf tmp_*
rm -rf *.txt
rm -rf *.xml
rm -rf *.json

echo {} > version.json

REM ------------------------------
REM Mozilla Firefox
REM ------------------------------
echo Get Mozilla Firefox latest version

REM 1. Get html for http://www.mozilla.org/en-US/firefox/new/
REM 2. Find and get href value in <li class='os_windows'><a href="xxxxxx">
REM 3. Save the url to tmp_firefox_file
xidel http://www.mozilla.org/en-US/firefox/new/ -e "//li[@class='os_windows']/a/@href" > tmp_firefox_file

REM 4. Get content of tmp_firefox_file and put to environment variable %url_firefox%
set /p url_firefox=<tmp_firefox_file

REM 5. Download the latest firefox
wget --no-check-certificate "%url_firefox%" -O tmp_firefox.exe

REM 6. Extract latest firefox file to tmp_firefox folder
7za.exe e tmp_firefox.exe -y -otmp_firefox

REM 7. Get version number from "tmp_firefox/firefox.exe" and append to version.txt
for /f "tokens=3" %%v in ('sigcheck "tmp_firefox/firefox.exe"^|find /i "version"') do set fileVersion=%%v

jq ".firefox = \"%fileVersion%\"" version.json > version.json.1
del version.json
ren version.json.1 version.json

REM ------------------------------
REM Oracle Java
REM ------------------------------
echo Get Oracle Java latest version

xidel http://java.com/en/download/chrome.jsp?locale=en -e "//a[@class='jvdla0']/@href" > tmp_java_file
set /p url_java=<tmp_java_file
wget --no-check-certificate "%url_java%" -O tmp_java.exe
for /f "tokens=3" %%v in ('sigcheck "tmp_java.exe"^|find /i "version"') do set fileVersion=%%v
jq ".java = \"%fileVersion%\"" version.json > version.json.1
del version.json
ren version.json.1 version.json

REM ------------------------------
REM Google Chrome
REM ------------------------------
echo Get Google Chrome latest version

wget --no-check-certificate https://tools.google.com/service/update2 --post-data "<?xml version='1.0' encoding='UTF-8'?><request protocol='3.0' version='1.3.21.135' shell_version='1.3.21.103' ismachine='1' sessionid='{8989B147-F32D-43EA-BB06-9901D388E712}' installsource='ondemandcheckforupdate' requestid='{4A6167C6-5DDA-435C-B306-D591CA20FB0D}'><os platform='win' version='6.1' sp='' arch='x86'/><app appid='{4DC8B4CA-1BDA-483E-B5FA-D3C12E15B62D}' version='0' nextversion='' ap='-multi-chrome' lang='' brand='GGLS' client=''><updatecheck/><ping active='1'/></app></request>" -O tmp_chrome.xml
REM tutorial about XMLStarlet http://dynamomd.org/index.php/tutorialA
xml sel -t -m "//manifest" -v "@version" tmp_chrome.xml > tmp_chrome
set /p fileVersion=<tmp_chrome
jq ".chrome = \"%fileVersion%\"" version.json > version.json.1
del version.json
ren version.json.1 version.json

REM ------------------------------
REM Microsoft Internet Explorer for XP
REM ------------------------------
echo Get Microsoft Internet Explorer for XP latest version

REM Minimum user agent for MSIE 6 (Win XP) is "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)"
xidel http://windows.microsoft.com/en-MY/internet-explorer/download-ie --user-agent="Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)" -e "(//span[@class='btnBase']/a/@href)[1]" > tmp_ie_xp_file
set /p url_ie_xp=<tmp_ie_xp_file
wget --user-agent="Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)" "%url_ie_xp%" -O tmp_ie_xp.exe
7za.exe e tmp_ie_xp.exe -y -otmp_ie_xp
for /f "tokens=3" %%v in ('sigcheck "tmp_ie_xp/iexplore.exe"^|find /i "version"') do set fileVersion=%%v
jq ".ie_xp = \"%fileVersion%\"" version.json > version.json.1
del version.json
ren version.json.1 version.json

REM ------------------------------
REM Microsoft Internet Explorer for Vista
REM ------------------------------
echo Get Microsoft Internet Explorer for Vista latest version

REM Minimum user agent for MSIE 7 (Vista) is "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)"
xidel http://windows.microsoft.com/en-MY/internet-explorer/download-ie --user-agent="Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)" -e "(//span[@class='btnBase']/a/@href)[1]" > tmp_ie_vista_file
set /p url_ie_vista=<tmp_ie_vista_file
wget --user-agent="Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)" "%url_ie_vista%" -O tmp_ie_vista.exe
for /f "tokens=3" %%v in ('sigcheck "tmp_ie_vista.exe"^|find /i "version"') do set fileVersion=%%v
jq ".ie_vista = \"%fileVersion%\"" version.json > version.json.1
del version.json
ren version.json.1 version.json


REM ------------------------------
REM Microsoft Internet Explorer for Windows 7 and 8
REM ------------------------------
echo Get Microsoft Internet Explorer for Windows 7 ad 8 latest version

REM Minimum user agent for MSIE 8 - standard mode (Win 7) is "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0)"
xidel http://windows.microsoft.com/en-MY/internet-explorer/download-ie --user-agent="Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0)" -e "(//span[@class='btnBase']/a/@href)[1]" > tmp_ie_win7_file
set /p url_ie_win7=<tmp_ie_win7_file
wget --user-agent="Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0)" "%url_ie_win7%" -O tmp_ie_win7.exe
for /f "tokens=3" %%v in ('sigcheck "tmp_ie_win7.exe"^|find /i "version"') do set fileVersion=%%v
jq ".ie_win7 = \"%fileVersion%\"" version.json > version.json.1
jq ".ie_win8 = \"%fileVersion%\"" version.json.1 > version.json.2
del version.json
del version.json.1
ren version.json.2 version.json


REM cleanup temporary files/folders
rm -rf tmp_*
rm -rf *.txt
rm -rf *.xml

