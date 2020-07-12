
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.#SingleInstance, force
#SingleInstance force
#Persistent

OnClipboardChange("CheckClipData")

global craftcontainer := []
global ShowData := 0
global Data

Gui, Data:New, -MaximizeBox -MinimizeBox
Gui, Data:Add, Edit,vShowData x10 y10 w580 h500 ReadOnly, use CRL+C to Copy Hortistations from your stash
Gui, Data:Add, Button, x504 y520, Sort
Gui, Data:Add, Button, x544 y520, Reset
Gui, Data:Show, x800 y100 w600 h550, Path of Exile - HortiCrafting Mods 
return

DataButtonRefresh:
	ShowDataBox()
return

DataButtonSort:
SortArray(craftcontainer)
	ShowDataBox()
return

DataButtonReset:
	craftcontainer := []
	ShowDataBox()
return


;Check Clip Data taken from https://github.com/Skullfurious/Hortisorty
CheckClipData()
{
  clip := Clipboard
  global lines := strSplit(clip, "`n")

  ;Horticrafting??
  if !(lines[2] ~= "Horticrafting Station")
 	return
  RegExMatch(lines.5, "\d", craftamount)

	while(craftamount > 0)
	{
	  position := 7 + craftamount
	  craftcontainer.push(lines[position])
	  craftamount := craftamount - 1
	}
  ShowDataBox()
  WinActivate, ahk_class POEWindowClass
  SetToolTip("processed!"`)
  return
}

GetDataAsText()
{
	Text := ""
	for k, v in craftcontainer
	{
		Text .=  v "`n"
	}
	return Text
}
ShowDataBox()
{
	Text := GetDataAsText()
	GuiControl,Data:, ShowData, %Text% 
	return
}

SetToolTip(t)
{
	MouseGetPos, xpos, ypos
	ToolTip, processed! , xpos + 15, ypos -15
	SetTimer, RemoveToolTip, -500
	return
}

RemoveToolTip()
{
	ToolTip
	return
}



; from https://sites.google.com/site/ahkref/custom-functions/sortarray
SortArray(Array, Order="A") {
    ;Order A: Ascending, D: Descending, R: Reverse
    MaxIndex := ObjMaxIndex(Array)
    If (Order = "R") {
        count := 0
        Loop, % MaxIndex
            ObjInsert(Array, ObjRemove(Array, MaxIndex - count++))
        Return
    }
    Partitions := "|" ObjMinIndex(Array) "," MaxIndex
    Loop {
        comma := InStr(this_partition := SubStr(Partitions, InStr(Partitions, "|", False, 0)+1), ",")
        spos := pivot := SubStr(this_partition, 1, comma-1) , epos := SubStr(this_partition, comma+1)    
        if (Order = "A") {    
            Loop, % epos - spos {
                if (Array[pivot] > Array[A_Index+spos])
                    ObjInsert(Array, pivot++, ObjRemove(Array, A_Index+spos))    
            }
        } else {
            Loop, % epos - spos {
                if (Array[pivot] < Array[A_Index+spos])
                    ObjInsert(Array, pivot++, ObjRemove(Array, A_Index+spos))    
            }
        }
        Partitions := SubStr(Partitions, 1, InStr(Partitions, "|", False, 0)-1)
        if (pivot - spos) > 1    ;if more than one elements
            Partitions .= "|" spos "," pivot-1        ;the left partition
        if (epos - pivot) > 1    ;if more than one elements
            Partitions .= "|" pivot+1 "," epos        ;the right partition
    } Until !Partitions
}
