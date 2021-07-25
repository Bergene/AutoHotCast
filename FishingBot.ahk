#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#Singleinstance force
#Include box.ahk

; Source: https://autohotkey.com/board/topic/78565-minecraft-utilities-fishing-bot-chest-xfer-auto-furnace/page-2
; Source: https://pastebin.com/zheRTs3E


;; Add check if bobber is anywhere on screen, if so, reel it in before casting.

CoordMode, Pixel, Screen
CoordMode, Mouse, Screen

Gui, +Owner  ; +Owner prevents a taskbar button from appearing.
Gui, Color, 000000
Gui, font, cWhite W100 s8, Verdana
Gui, Add, Text, vMyText x5 y5 w250 r4
Gui, +ToolWindow
Gui, +AlwaysOnTop
Gui, Show, NA x0 yCenter w300 h75
Gui, +Resize
Gui, Add, Picture, vMyPic w5 x5


MouseGetPos, xpos, ypos
x1 := xpos-15
y1 := ypos-25
x2 := xpos+82
y2 := ypos+58
box_x :=xpos-75
box_y :=ypos-75

updateOSD("Idle")

toggle = 0
search_delay = 2000
search2_delay = 250
saerch2_loop_delay = 50
recast_delay = 800
nibble_delay = 250

#MaxThreadsPerHotkey 2
#InstallMouseHook

Box_Init("0F9D58")


+!r::Reload
+!q::ExitApp

*F4:: ;auto types /home. Use when you fall into lava, start drowning, or to escape a hissing creeper after a skeleton pushes you off of a ledge
	BlockInput,  Send
	Send, t
	sleep 100
	SendInput, {Raw}/home
	sleep 100
	SendInput, {Enter}
	;BlockInput, Off
	return
	
RButton::
	if (Toggle){
		Toggle := !Toggle
	}
	else
		Click Right
return

+!f:: ;autofisher
{
    Toggle := !Toggle
    If (!Toggle){
		updateOSD("Toggle Off")
	}
	else{
		Box_Draw(box_x, box_y, 151, 151)
		goto Begin
	}
return
}


Begin:
	If (!Toggle){
		goto ReelIn					
	}
	else if (Toggle){
		updateOSD("Begin`r`nCasting")		
		Click Right	
		Sleep search_delay	
		goto Search
	}
return
		

;find the bobber on the screen
Search:
	If (!Toggle){
		goto ReelIn
	}
	else{
		PixelSearch, FoundX, FoundY, x1, y1, x2, y2, 560E10,, fast RGB
		if ErrorLevel = 2
			MsgBox Could not find the bobber image file.
		else if ErrorLevel = 1
		{
			updateOSD("Search1`r`nBobber Not Found")
			goto Search
		}
		else
		{
			updateOSD("Search1`r`nUpper left: " . x1 " , " . y1 "`r`nLower right: " . x2 ", " . y2 "`r`nTracking at  x: " . FoundX . " y: " . FoundY)
			Sleep search2_delay
			goto Search2
		}
	}
return

		
;bobber was found. now track the bobber and wait for it to go underwater
Search2:
	If (!Toggle){
		goto ReelIn
	}
	else{
		PixelSearch, FoundX, FoundY, x1, y1, x2, y2, 560E10,, fast RGB
		if ErrorLevel = 2
			MsgBox Could not find the bobber image file.
		else if ErrorLevel = 1
		{
			updateOSD("Search2`r`nPotential Bite")
			goto Search3
		}
		else
		{
			updateOSD("Search2`r`nUpper left: " . x1 " , " . y1 "`r`nLower right: " . x2 ", " . y2 "`r`nTracking at  x: " . FoundX . " y: " . FoundY)
			Sleep saerch2_loop_delay
			goto Search2
		}
	}
return
			
		
Search3:
	If (!Toggle){
		goto ReelIn
	}
	else{
		PixelSearch, FoundX, FoundY, x1, y1, x2, y2, 560E10,, fast RGB
		if ErrorLevel = 2
			MsgBox Could not find the bobber image file.
		else if ErrorLevel = 0
			updateOSD("Search3`r`nLOST THE BOBBER")
		else if ErrorLevel = 1
		{
			PixelSearch, FoundX, FoundY, x1, y1, x2, y2, 560E10,, fast RGB
			if ErrorLevel = 1
			{
				updateOSD("Search3`r`n**REELING**")
				Click Right
				Sleep recast_delay
				goto Begin
			}
			else
				updateOSD("Search3`r`nJust a nibble")
				Sleep nibble_delay
				goto Search
		}
	}
return
			
		
ReelIn:
	updateOSD("Idle")
	BlockInput, Off
	Click Right
	Box_Hide()
return




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


