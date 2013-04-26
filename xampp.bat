@echo off
rem kopiert die Dateien aus der Arbeits- in die Testumgebung

rem kopieren aller CGI-Dateien 
xcopy /s cgi\* C:\xampp\cgi-bin\rocket\

rem kopieren der CSS-Datei
xcopy css\* C:\xampp\htdocs\css\

rem kopieren des Datenbankkonfigurationsscripts
xcopy sql\* C:\xampp\cgi-bin\sql\
