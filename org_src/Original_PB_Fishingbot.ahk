#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#Singleinstance force
;#include gdip.ahk

; Source: https://pastebin.com/zheRTs3E


CoordMode, Pixel, Screen
CoordMode, Mouse, Screen

Gui, +Owner  ; +Owner prevents a taskbar button from appearing.
Gui, Color, 000000
Gui, font, cWhite W100 s8, Verdana
Gui, Add, Text, vMyText x5 y5 w250 r3
Gui, +ToolWindow
Gui, +AlwaysOnTop
Gui, Show, NA x0 yCenter w250 h75
Gui, +Resize
Gui, Add, Picture, vMyPic w5 x5

updateOSD("Idle")
toggle = 0
#MaxThreadsPerHotkey 2
#InstallMouseHook

;currentItem := "temp"


/* if (!pToken:=Gdip_Startup()) {
 *       msgbox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
 *       ExitApp
 *    }
 */
 ^p:: ;QUIT
Gui, Destroy
;Gdip_Shutdown(pToken)
ExitApp
Return  

*F4:: ;auto types /home. Use when you fall into lava, start drowning, or to escape a hissing creeper after a skeleton pushes you off of a ledge
	BlockInput,  Send
	Send, t
	sleep 100
	SendInput, {Raw}/home
	sleep 100
	SendInput, {Enter}
	BlockInput, Off
	return
	
+!k:: ;autofisher
{
    Toggle := !Toggle
    If (!Toggle){
		updateOSD("--REELING--")
		Click Right
		Sleep 500
		goto Begin
	}
BlockInput, MouseMove
	Begin:
    If (!Toggle){
		updateOSD("--REELING--")
		Click Right
		Sleep 500
		goto Begin
	}
	updateOSD("Casting")
		Click Right
		Sleep 2000
		BlockInput, MouseMoveOff
	
	;find the bobber on the screen
	Search:
    If (!Toggle){
		updateOSD("--REELING--")
		Click Right
		Sleep 500
		goto Begin
	}
	ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *40 %A_ScriptDir%\bobber.png
if ErrorLevel = 2
    MsgBox Could not find the bobber image file.
else if ErrorLevel = 1
{
	updateOSD("Bobber Not Found")
   goto Search
}
else
{
   ; MsgBox The icon was found at %FoundX%x%FoundY%.
	updateOSD("Tracking at  x: " . FoundX . " y: " . FoundY)
	Sleep 100
	goto Search2
}
	;bobber was found. now track the bobber and wait for it to go underwater
	Search2:
    If (!Toggle){
		updateOSD("--REELING--")
		Click Right
		Sleep 500
		goto Begin
	}
	ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *40 %A_ScriptDir%\bobber.png
if ErrorLevel = 2
    MsgBox Could not find the bobber image file.
else if ErrorLevel = 1
{
   updateOSD("Potential Bite")
   goto Search3
}
else
{
	updateOSD("Tracking at  x: " . FoundX . " y: " . FoundY)
   Sleep 100
	goto Search2
}
		Search3:
    If (!Toggle){
		updateOSD("--REELING--")
		Click Right
		Sleep 500
		goto Begin
	}
	ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *100 %A_ScriptDir%\bobber.png
if ErrorLevel = 2
    MsgBox Could not find the bobber image file.
else if ErrorLevel = 1
	updateOSD("LOST THE BOBBER")
else
{
	ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *40 %A_ScriptDir%\bobber.png
	if ErrorLevel = 1
	{
		updateOSD("**REELING**")
		Click Right
		Sleep 500
		goto Begin
	}
	else
		updateOSD("Just a nibble")
		Sleep 250
		goto Search
}
updateOSD("--REELING--")
Click Right
Sleep 500
goto Begin
}
	
refreshOSD()
{
	global
	Gui, Show, NA x0 yCenter AutoSize
	return
}

updateOSD(string)
	{
		global
		osdText=%string%
		if(class_control="true")
			{
				IfWinActive, ahk_class %class%
					GuiControl,, MyText, %osdText%
			}
		else
			GuiControl,, MyText, %osdText%
		;Gui, Show, x0 yCenter AutoSize
		;SetTimer,unshowOSD,2500
		return
	}


+!r::Reload
+!q::ExitApp