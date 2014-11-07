# README

# This folder includes all our UI Testing using Selenium.

## Local Setup
```
TestNG is best suited for Eclipse IDE environment; download Eclipse from https://www.eclipse.org/downloads/

Create new project in Eclipse 'cs169UITesting'

Download Selenium Java WebDriver Language Binding at http://docs.seleniumhq.org/download/
Right click project folder -> Properties -> Java Build Path -> Libaries -> Add External Jars -> Add all the jar files
you downloaded from the url.

Download chromedriver.exe from http://chromedriver.storage.googleapis.com/index.html into your C:/
If chromedriver.exe is not in your C:/ drive, change in UITestHousemates.java field 'chromedriverPath' to correct path.

Follow instructions here to add TestNG to Eclipse: http://testng.org/doc/download.html
If the above doesn't work, in Eclipse go to Help -> Eclipse Marketplace... -> Search TestNG

Right-click testng.xml -> Run As -> TestNG Suite.
```

