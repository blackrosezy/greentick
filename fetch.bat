@echo off
setlocal EnableDelayedExpansion 

echo Check latest version
xidel http://www.mozilla.org/en-US/firefox/new/ -e "//li[@class='os_windows']/a/@href" > tmp_firefox
set /p url=<tmp_firefox
wget --no-check-certificate "%url%" -O firefox.exe
del tmp_firefox
7za.exe e firefox.exe -y -ofirefox
