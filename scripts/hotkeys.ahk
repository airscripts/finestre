#Enter::
 Run "C:\Users\Airscript\AppData\Local\Microsoft\WindowsApps\wt.exe"
 Return

#+Q::
 WinGetTitle, Title, A
 PostMessage, 0x112, 0xF060,,, %Title%
 return
