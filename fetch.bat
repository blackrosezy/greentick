@echo off
setlocal EnableDelayedExpansion 

echo Check latest version
xidel http://www.mozilla.org/en-US/firefox/new/ -e "//li[@class='os_windows']/a/@href" > tmp_firefox
set /p url_firefox=<tmp_firefox
wget --no-check-certificate "%url_firefox%" -O firefox.exe
del tmp_firefox
7za.exe e firefox.exe -y -ofirefox


xidel http://java.com/en/download/chrome.jsp?locale=en -e "//a[@class='jvdla0']/@href" > tmp_java
set /p url_java=<tmp_java
wget --no-check-certificate "%url_java%" -O java.exe
del tmp_java
