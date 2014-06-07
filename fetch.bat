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
xidel http://www.mozilla.org/en-US/firefox/all/ -e "//td[@class='download win']/a/@href" > tmp_firefox_file

REM 4. Get content of tmp_firefox_file and put to environment variable %url_firefox%
set /p url_firefox=<tmp_firefox_file

REM 5. Download the latest firefox
wget --no-check-certificate "%url_firefox%" -O tmp_firefox.exe

REM 6. Extract latest firefox file to tmp_firefox folder
7za.exe e tmp_firefox.exe -y -otmp_firefox

REM 7. Get version number from "tmp_firefox/firefox.exe" and append to version.txt
for /f "tokens=3" %%v in ('sigcheck "tmp_firefox/firefox.exe" /accepteula^|find /i "version"') do set fileVersion=%%v

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
for /f "tokens=3" %%v in ('sigcheck "tmp_java.exe" /accepteula^|find /i "version"') do set fileVersion=%%v
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


REM cleanup temporary files/folders
rm -rf tmp_*
rm -rf *.txt
rm -rf *.xml

