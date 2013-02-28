@echo off

#CGI Dateien auf XAMPP kopieren
copy cgi\* C:\xampp\cgi-bin\RocketTS\

#CSS Dateien auf XAMPP kopieren
copy css\* C:\xampp\htdocs\css\

#Restliche Dateien auf XAMPP kopieren
copy sql\* C:\xampp\htdocs\sql\
copy doku\* C:\xampp\htdocs\doku\