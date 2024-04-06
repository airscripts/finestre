﻿DesktopCount = 4
CurrentDesktop = 1

mapDesktopsFromRegistry() {
  global CurrentDesktop, DesktopCount
  IdLength := 32
  SessionId := getSessionId()

  if (SessionId) {
    RegRead, CurrentDesktopId, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SessionInfo\%SessionId%\VirtualDesktops, CurrentVirtualDesktop
    
    if (CurrentDesktopId) {
      IdLength := StrLen(CurrentDesktopId)
    }
  }

  RegRead, DesktopList, HKEY_CURRENT_USER, SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops, VirtualDesktopIDs

  if (DesktopList) {
    DesktopListLength := StrLen(DesktopList)
    DesktopCount := DesktopListLength / IdLength
  }
 
  else {
    DesktopCount := 1
  }

  i := 0

  while (CurrentDesktopId and i < DesktopCount) {
    StartPos := (i * IdLength) + 1
    DesktopIter := SubStr(DesktopList, StartPos, IdLength)
    OutputDebug, The iterator is pointing at %DesktopIter% and count is %i%.
  
    if (DesktopIter = CurrentDesktopId) {
      CurrentDesktop := i + 1
      OutputDebug, Current desktop number is %CurrentDesktop% with an ID of %DesktopIter%.
      break
    }
    
    i++
  }
}

getSessionId() {
  ProcessId := DllCall("GetCurrentProcessId", "UInt")
  
  if ErrorLevel {
    OutputDebug, Error getting current process id: %ErrorLevel%
    return
  }

  OutputDebug, Current Process Id: %ProcessId%
  DllCall("ProcessIdToSessionId", "UInt", ProcessId, "UInt*", SessionId)
  
  if ErrorLevel {
    OutputDebug, Error getting session id: %ErrorLevel%
    return
  }

  OutputDebug, Current Session Id: %SessionId%
  return SessionId
}

switchDesktopByNumber(targetDesktop) {
  global CurrentDesktop, DesktopCount
  mapDesktopsFromRegistry()

  if (targetDesktop > DesktopCount || targetDesktop < 1) {
    OutputDebug, [invalid] target: %targetDesktop% current: %CurrentDesktop%
    return
  }

  while(CurrentDesktop < targetDesktop) {
    Send ^#{Right}
    CurrentDesktop++
    OutputDebug, [right] target: %targetDesktop% current: %CurrentDesktop%
  }

  while(CurrentDesktop > targetDesktop) {
    Send ^#{Left}
    CurrentDesktop--
    OutputDebug, [left] target: %targetDesktop% current: %CurrentDesktop%
  }
}

SetKeyDelay, 75
mapDesktopsFromRegistry()
OutputDebug, [loading] desktops: %DesktopCount% current: %CurrentDesktop%

^#Left::switchDesktopByNumber(CurrentDesktop-1)
^#Right::switchDesktopByNumber(CurrentDesktop+1)

#1::switchDesktopByNumber(1)
#2::switchDesktopByNumber(2)
#3::switchDesktopByNumber(3)
#4::switchDesktopByNumber(4)