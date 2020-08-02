#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=GenMdP2.ico
#AutoIt3Wrapper_Outfile_x64=GenMdP2.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Add_Constants=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.15.0 (Beta)
 Author:         DDA209

 Script Function:
	Générateur de mots de passe

#ce ----------------------------------------------------------------------------
#include <Array.au3>
#include <GuiConstantsEx.au3>
#include <ButtonConstants.au3>

; Dimensions de la fenêtre
Const $winWdt = 600
Const $winHei = 400
Const $winBrd = 10

; Définition des boution
Const $btnBdrTop = 10
Const $btnWdt = 90
Const $btnHei = 25
Const $btn1BrdLft = $winWdt - $btnWdt - $winBrd
Const $btnIntSpc = 3
Const $btnNbr = 4

; Zone d'information
Const $msgLen = 268
Const $msgHei = 13


; Zone de sélection des critères du mot de passe
Const $inpBrdLft = $winBrd + 55
Const $inpBrdTop = 10
Const $inpWdt = 50
Const $inpHei = 20
Const $lblBrdTop = $inpBrdTop + 3
Const $dspBrdTop = $btnNbr * $btnHei + ($btnNbr - 1) * $btnIntSpc + 2 * $winBrd

; checkbox
Const $chkIntSpc = 10
Const $inpChkLft = $inpBrdLft + 60
Const $chkWdt = $winWdt - 3 * $inpBrdTop - $inpChkLft - $btnWdt


; Création de la fenêtre
GUICreate("Gen PW v2.0 - DDA209", $winWdt, $winHei)


Local $charLen
Local $charsConcat = []

; Mise en place des éléments graphiques
Const $generate = GUICtrlCreateButton("Générer", $btn1BrdLft, $btnBdrTop, $btnWdt, $btnHei)
Const $clear = GUICtrlCreateButton("Vider la liste", $btn1BrdLft, $btnBdrTop + ($btnIntSpc + $btnHei), $btnWdt, $btnHei)
Const $export = GUICtrlCreateButton("Exporter la liste", $btn1BrdLft, $btnBdrTop + 2 * ($btnIntSpc + $btnHei), $btnWdt, $btnHei)
Const $quit = GUICtrlCreateButton ( "Fermer", $btn1BrdLft, $btnBdrTop + 3 * ($btnIntSpc + $btnHei), $btnWdt,$btnHei )

; Caractéristiques des mots de passe
Const $charNum = "0123456789"
Const $charMin = "azertyuiopqsdfghjklmwxcvbn"
Const $charMaj = "AZERTYUIOPQSDFGHJKLMWXCVBN"
Const $charAcc = "éèàçùÈÀÒìÌòÙñÑäÄëËÿüÜïÏöÖ"
Const $charSp1 = "&""'(-_)=#{[\@]}+°€$£*µ%!§:/;.?<>² ¤|"

; Mise en place des checkboxes
Const $charSectionNum = GUICtrlCreateCheckbox("Chiffres de 0 à 9", $inpChkLft, $winBrd + 0 * ($chkIntSpc + $msgHei), $chkWdt, $msgHei)
Const $charSectionUpp = GUICtrlCreateCheckbox("Lettres minuscules non accentuées", $inpChkLft, $winBrd + 1 * ($chkIntSpc + $msgHei), $chkWdt, $msgHei)
Const $charSectionLow = GUICtrlCreateCheckbox("Lettres MAJUSCULES non accentuées", $inpChkLft, $winBrd + 2 * ($chkIntSpc + $msgHei), $chkWdt, $msgHei)
Const $charSectionAcc = GUICtrlCreateCheckbox("Lettres accentuées (minus et maj)", $inpChkLft, $winBrd + 3 * ($chkIntSpc + $msgHei), $chkWdt, $msgHei)
Const $charSectionSpx = GUICtrlCreateCheckbox("Caractères spéciaux", $inpChkLft, $winBrd + 4 * ($chkIntSpc + $msgHei), $chkWdt, $msgHei)

Local $charSelection = ""

GUICtrlCreateLabel("Longueur : ", $winBrd, $lblBrdTop)
Local $size = (GUICtrlCreateInput("4", $inpBrdLft, $inpBrdTop, $inpWdt, $inpHei))
GUICtrlCreateUpdown($size)

Local $finalPW

Local $listPW

Local $display = GUICtrlCreateEdit("Les mots de passe seront affichés ici.", $winBrd, $dspBrdTop, $winWdt - 2 * $winBrd, $winHei - $dspBrdTop - $winBrd)
GUICtrlSetColor(-1, 0x005005)
GUICtrlSetBkColor(-1, 0xd0ffe8)

Local $message = GUICtrlCreateLabel("", $winBrd, $inpBrdTop + 30, 105, 47)
GUICtrlSetBkColor (-1, 0xfafafa)



; Zone de messages
Local $msg0 = "/!\ Le dernier mot de passe sera collé dans le presse papier"
Local $msg1 = "Le dernier mot de passe a été collé dans le presse papier"
GUICtrlSetData($message, $msg0)
GUICtrlSetBkColor($message, 0xffb0a0)

App() ; démarrage de l'application

Func App()

	GUISetState() ; génération de la fenêtre
	While 1
		Switch GUIGetMsg()

			Case $generate
				If GUICtrlRead($size) > 0 And GUICtrlRead($size) < 1000 Then
					GeneratePW()  ; Génération d'un mot de passe
				Else
					MsgBox(0, "Erreur de saisie", "Veuillez entrer une valeur entre 1 et 1000", 0, 0x10)
				EndIf

			Case $clear
				GUICtrlSetData($display, "")
				$finalPW = ""
				$listPW = ""
				ClipPut($finalPW)
				GUICtrlSetData($message, "")

			Case $export
				ExportList() ; Récupération de la liste de mots de passes

			Case $GUI_EVENT_CLOSE
				ExitLoop ; Permet de quitter l'application

			Case $quit
				ExitLoop

		EndSwitch

	WEnd

EndFunc   ;==>App

Func GeneratePW()

	CharConcat()

	Local $i = 1
	$finalPW = ""

;~  MsgBox(0,"",GUICtrlRead($size) & " - "& $size,1)
;~ 	MsgBox(0,"chaine pour PW", " $charSelection = " & $charSelection)

	If $charSelection == "" Then
		MsgBox(0x10, "Choix éronné de caractères", "Cocher au moins 1 type de carctères")
	Else
;~ 		MsgBox(0, "Longueurs de chaînes", "$charLen = " & $charLen & @CRLF & "$charsConcat[Random(0, $charLen -1)] = " & Floor(Random(0, $charLen -1)))
		For $i = 1 To GUICtrlRead($size) Step 1
	;~ 		 $finalPW = $finalPW & $char [ Random ( 0, $arrayLen - 1 ) ]
			Local $letterIndex = Ceiling(Random(0, $charLen))
			Local $tmpLetter = $charsConcat[$letterIndex]
			$finalPW = $finalPW & $tmpLetter
;~ 			MsgBox(0, "lettre", "Lettre : " & $tmpLetter & @CRLF & "Index : " & $letterIndex)
		Next
		ClipPut($finalPW)
		GUICtrlSetData($message, $msg1)
		GUICtrlSetBkColor($message, 0xfafafa)
		$listPW = $listPW & $finalPW & @CRLF
		GUICtrlSetData($display, $listPW, "")
		GUICtrlSetColor($display, 0x0010a0)
		GUICtrlSetBkColor($display, 0xe8f0ff)
	EndIf

EndFunc   ;==>GeneratePW

Func ExportList()

	Local $listFile = "PW list.txt"
	$listExtract = "Liste générée le " & @MDAY & "/" & @MON & "/" & @YEAR & " à " & @HOUR & ":" & @MIN & ":" & @SEC & "," & @MSEC & " :" & @CRLF & @CRLF & $listPW & @CRLF & @CRLF
	FileWrite($listFile, $listExtract)
	MsgBox(0x40,"Listes exportée", "La liste a été exporté dans le fichier : " & $listFile)

EndFunc   ;==>ExportList

Func CharConcat()

;~ 	MsgBox(0,"confirme", "CharConcat()")
	$charSelection = ""

	If GUICtrlRead($charSectionNum) == 1 Then
		$charSelection &= $charNum
;~ 		MsgBox(0, "Sélection de caractères", "$charSelection = " & $charSelection & " / $charNum = " & $charNum)
	EndIf

	If GUICtrlRead($charSectionUpp) == 1 Then
		$charSelection &= $charMin
;~ 		MsgBox(0, "Sélection de caractères", "$charSelection = " & $charMaj & " / $charNum = " & $charMaj)
	EndIf

	If GUICtrlRead($charSectionLow) == 1 Then
		$charSelection &= $charMaj
;~ 		MsgBox(0, "Sélection de caractères", "$charSelection = " & $charMin & " / $charNum = " & $charMin)
	EndIf

	If GUICtrlRead($charSectionAcc) == 1 Then
		$charSelection &= $charAcc
;~ 		MsgBox(0, "Sélection de caractères", "$charSelection = " & $charAcc & " / $charNum = " & $charAcc)
	EndIf

	If GUICtrlRead($charSectionSpx) == 1 Then
		$charSelection &= $charSp1
;~ 		MsgBox(0, "Sélection de caractères", "$charSelection = " & $charSelection & " / $charSp1 = " & $charSp1)
	EndIf

;~ 	MsgBox(0,"cases cochées", GUICtrlRead($charSectionNum) & @CRLF & GUICtrlRead($charSectionUpp) & @CRLF & GUICtrlRead($charSectionLow) & @CRLF & GUICtrlRead($charSectionAcc) & @CRLF & GUICtrlRead($charSectionSpx))

	If GUICtrlRead($charSectionNum) == 4 And GUICtrlRead($charSectionUpp) == 4 And GUICtrlRead($charSectionLow) == 4 And GUICtrlRead($charSectionAcc) == 4 And GUICtrlRead($charSectionSpx) == 4 Then
		$charSelection = ""
	EndIf

	$charLen = StringLen($charSelection)
;~ 	$charsConcat[$charLen] = StringSplit($charSelection, "")
	$charsConcat = StringSplit($charSelection, "")

;~ 	MsgBox(0, "", "selection : " & $charSelection & @CRLF & "split : " & $charsConcat & @CRLF & "8e caractere : " &  @CRLF & @CRLF & "Listes :" & @CRLF & $charNum & @CRLF & $charMaj & @CRLF & $charMin & @CRLF & $charAcc & @CRLF & $charSp1 & @CRLF & GUICtrlRead($charSectionNum) & @CRLF & GUICtrlRead($charSectionUpp) & @CRLF & GUICtrlRead($charSectionLow) & @CRLF & GUICtrlRead($charSectionAcc) & @CRLF & GUICtrlRead($charSectionSpx) & @CRLF & @CRLF & $charLen)

EndFunc   ;==>CharConcat
