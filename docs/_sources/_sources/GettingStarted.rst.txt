Getting Started
==================================

These CPS macros are made with `AutoHotKey <https://www.autohotkey.com/>`_ -- an open source Windows macro utility that's over 15 years old. Our macros we built to automate small/frequent pain points for CPS users. Some of the macros have been in production use for 5 years. The CPS macros were more systematically developed for FCN in 2019 using CPS 12.2. Brief testing with 12.3 shows that they work with that version, too. There were dozens of other macros over time. The current macros are the highlights because they are more generally useful for us and relatively easy for users to learn.

.. image:: welcome-splashscreen.png
    :width: 467px
    :align: center
    :height: 97px

These are provided as is -- if something changes in CPS versions, it could make a step in a macro not work. At FCN, we run CPS on Windows Server and client software is accessed through Citrix. If a macro isn't working on your CPS, you can try fixing it by looking at the source code. The main code file is 'FCN-Macros-Beta.ahk'.


These macros can be installed two ways: 

* locally on a Windows computer. 
* or on the server for CPS (say, when using Citrix like at FCN). 

It's most reliable if the Macros live in the same computer as the CPS client software. You could install it locally on a Windows computer and access through Citrix. Say, to test it out. But that changes the speed and accuracy of certain steps for macros and decreases reliability. For example, imagine you download this to your laptop and start the macros there. If you log into Citrix to open CPS, it might not work a reliably. 

So if you just want to try it out, feel free to open it on on your desktop. But if you're actually deploying this for your organization, you'll probably want to put it on the server if you use citrix. 


Local Installation 
---------------------------------------------------

* Download files and double click on FCN-Hotkeys-Beta.exe
* The software asks one question: who's your buddy. It's the person you route updates to the most.
* You should be ready to start a walkthrough of key features.

Installation on Server
-------------------------------------------------

.. note:: I'm *not* an IT provider so these directions are vague.

* Put files on a jboss server or something like that.
* Create a quicktext to launch (if you'd like to keep it hidden from CPS users until you've tested it out.) We use this to as a quicktext named .alphatest to launch our test version. This allows us to have a place to adjust macros without touching the production one. Note the escaped backslashes and adjust for your setup.
::

	{runshellopen("\\\\fcnjboss01.fcn.net\\ahk$\\alpha-test.exe")}

* Create a Custom Command on the Toolbar for users to launch
* The script saves a preference of a 'buddy' -- it will be in the same folder as the script by default. At FCN we use a separate folder on the server. This can be set in the 'setup() function'.
* By default, the logging/telemetry features are disabled. The macro will create preferences and a log-file when it starts.

Making it your own
--------------------------------------------------

Feel free to make this your own. Maybe you'd like to change the splashscreen or tray icon. Just replace the image files in the files folder with your own. 

We use CPOE Appends and Phone Notes the most at FCN. So we have those automated -- if you use a different form for clinical communication, search the code file for CPOE to get started. 

If you're interested in knowing specific coordinates (say for a button to click), the AU3_Spy.exe application shows you all the details that Autohotkey can detect. 

Open up `AutoHotKey's Website <https://www.autohotkey.com/>`_ and look through the documentation as you're trying to figure parts out.
