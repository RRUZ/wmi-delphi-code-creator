call "C:\Program Files (x86)\Embarcadero\RAD Studio\11.0\bin\rsvars.bat"
msbuild.exe "WDCC.dproj" /target:clean;build /p:Platform=Win32 /p:config=release

pause