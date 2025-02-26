local shared = ...


local rot = 2 -- numero item a modifier (commande par rotary)
  
  
  
function shared.run(event)
  lcd.clear()



---- touche bascule entre ecran -----------------
 if event == EVT_VIRTUAL_MENU then -- bouton menu 
 playTone(1200, 120,5) -- play tone
    shared.changeScreen(6)
  end
  
 if event == EVT_VIRTUAL_MENU_LONG then -- bouton menu 
 playTone(1200, 120,5) -- play tone
    shared.changeScreen(1)
  end

  
	if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
    rot = rot+1 -- allez item suivant
		if (rot >10) then -- max item
		rot =10
		else
		 playTone(1200, 120,5) -- play tone
		end
	end
	if event == EVT_VIRTUAL_PREV then -- bouton rotary  prev
    playTone(1200, 120,5) -- play tone
	rot = rot-1
		if (rot <2) then
		shared.changeScreen(9)
		
		end
	end

  
  
  

	  
	  
	  if rot == 2 then -- PAGE 0	  
lcd.drawText(1, 1, "PAGE 1: accueil 1                   " , 0+INVERS) -- TITRE	  


lcd.drawText(1, 11, "TRM St.mod" , SMLSIZE+INVERS) -- texte fond noir
lcd.drawText(lcd.getLastPos(), 11, " Delta de reglage" , SMLSIZE) -- texte fond noir
lcd.drawText(1, 20, "Rapide SA si Switch SA pas" , SMLSIZE) -- texte fond noir
lcd.drawText(1, 29, "centre" , SMLSIZE) -- texte fond noir
lcd.drawText(lcd.getLastPos()+5, 29, "DR BR.Abs" , SMLSIZE+INVERS) -- texte fond noir
lcd.drawText(lcd.getLastPos()-1, 29, " Reglage ABS" , SMLSIZE) -- texte fond noir
lcd.drawText(1, 38, "si gachette en freinage" , SMLSIZE) -- texte fond noir
lcd.drawText(1, 46, "MOD BR.Drg" , SMLSIZE+INVERS) -- texte fond noir
lcd.drawText(lcd.getLastPos(), 46, " Reglage Drg Brake" , SMLSIZE) -- texte fond noir
lcd.drawText(1, 55, "si gachette en freinage" , SMLSIZE) -- texte fond noir
end  
	  
	  
if rot == 3 then -- PAGE 1	  
lcd.drawText(1, 1, "PAGE 1: accueil 2                   " , 0+INVERS) -- TITRE	  
 
lcd.drawText(1, 11, "ENTER" , SMLSIZE+INVERS) -- texte fond noir
lcd.drawText(lcd.getLastPos(), 11, " Modif timer 2" , SMLSIZE) 
lcd.drawText(1, 20, "ENTER Lg" , SMLSIZE+INVERS) -- texte fond noir  
lcd.drawText(lcd.getLastPos(), 20, " Menu reset session" , SMLSIZE)  
lcd.drawText(1, 29, "ROTARY" , SMLSIZE+INVERS) -- texte fond noir
 lcd.drawText(lcd.getLastPos(), 29, " Choix valeurs telem" , SMLSIZE) 
lcd.drawText(1, 38, "SC" , SMLSIZE+INVERS) -- texte fond noir
 lcd.drawText(lcd.getLastPos(), 38, " lap" , SMLSIZE) 
lcd.drawText(32, 38, "SC Long" , SMLSIZE+INVERS) -- texte fond noir 
 lcd.drawText(lcd.getLastPos(), 38, " Start & Reset" , SMLSIZE) 
  lcd.drawText(1, 47, "timer 2, annonce minute," , SMLSIZE) 
lcd.drawText(1, 56, "log telem" , SMLSIZE)

end  
  
if rot == 4 then -- PAGE 2	  
	 lcd.drawText(1, 1, "PAGE 2: log session                   " , 0+INVERS) -- TITRE 
  
  lcd.drawText(1, 11, "ENTER" , SMLSIZE+INVERS) -- texte fond noir
lcd.drawText(lcd.getLastPos(), 11, " Retour session 1" , SMLSIZE) 
lcd.drawText(1, 20, "ROTARY" , SMLSIZE+INVERS) -- texte fond noir
 lcd.drawText(lcd.getLastPos(), 20, " Choix session" , SMLSIZE) 
  
  
end  

if rot == 5 then -- PAGE 3	  
	lcd.drawText(1, 1, "PAGE 3: memoire setup                   " , 0+INVERS) -- TITRE  
  
  
    lcd.drawText(1, 11, "ENTER" , SMLSIZE+INVERS) -- texte fond noir
lcd.drawText(lcd.getLastPos(), 11, " Modif" , SMLSIZE) 
lcd.drawText(1, 20, "ROTARY" , SMLSIZE+INVERS) -- texte fond noir
 lcd.drawText(lcd.getLastPos(), 20, " Choix memoire" , SMLSIZE) 
  
  lcd.drawText(1, 29, "TRIM / POT ou VOLANT" , SMLSIZE+INVERS) -- texte fond noir
 lcd.drawText(lcd.getLastPos(), 29, " Affiche" , SMLSIZE) 
  lcd.drawText(1, 38, "temporairement les valeurs" , SMLSIZE) 
   lcd.drawText(1, 47, "actuelles" , SMLSIZE) 
end  

if rot == 6 then -- PAGE 4	  
	lcd.drawText(1, 1, "PAGE 4: Lap timer                        " , 0+INVERS) -- TITRE  
  
  
    lcd.drawText(1, 11, "Trigger lap auto" , SMLSIZE+INVERS) -- texte fond noir
lcd.drawText(lcd.getLastPos(), 11, "  Declenche" , SMLSIZE) 
lcd.drawText(1, 20, "auto lap avec suite gaz puis" , SMLSIZE) 
lcd.drawText(0, 29, "volant. Lap" , SMLSIZE) 
lcd.drawText(50, 29, "0 reste manuel au" , SMLSIZE) 
lcd.drawText(1, 38, "switch. Rond indique trigger" , SMLSIZE) 

    lcd.drawText(1, 46, "Bip alerte Best Lap" , SMLSIZE+INVERS) -- texte fond noir  

lcd.drawText(lcd.getLastPos(), 46, "  Bip au" , SMLSIZE) 
lcd.drawText(1, 55, "moment du best lap" , SMLSIZE) 
end  



if rot == 7 then -- PAGE 4	  
	lcd.drawText(1, 1, "PAGE 5: LOG Viewer                        " , 0+INVERS) -- TITRE  
  
  
    lcd.drawText(1, 11, "Toujours avoir mini 1 fichier" , SMLSIZE) -- texte fond noir
	 lcd.drawText(1, 20, "Log CSV par model pour " , SMLSIZE) -- texte fond noir
	  lcd.drawText(1, 29, "eviter BUG" , SMLSIZE) -- texte fond noir
	lcd.drawText(1, 38, "Nom de model avec maxi 3" , SMLSIZE) -- texte fond noir
	lcd.drawText(1, 47, "caracteres" , SMLSIZE) -- texte fond noir

end  








if rot == 8 then -- PAGE 6	  
	lcd.drawText(1, 1, "PAGE 6: configuration 1                   " , 0+INVERS) -- TITRE  
  
  
    lcd.drawText(1, 11, "Thr Speed point" , SMLSIZE+INVERS) -- texte fond noir
lcd.drawText(lcd.getLastPos(), 11, " Point avant" , SMLSIZE) 
lcd.drawText(1, 20, "lequel vitesse gaz  reduite" , SMLSIZE) 

    lcd.drawText(1, 29, "Feeling St" , SMLSIZE+INVERS) -- texte fond noir
lcd.drawText(lcd.getLastPos(), 29, " Vitesse reaction" , SMLSIZE) 

    lcd.drawText(1, 38, "DRAG Brake" , SMLSIZE+INVERS) -- texte fond noir  
	lcd.drawText(lcd.getLastPos()+5, 38, "Rise Time" , SMLSIZE+INVERS) -- texte fond noir
lcd.drawText(lcd.getLastPos(), 38, " Temps" , SMLSIZE) 
lcd.drawText(1, 47, "augmentation Drag brake" , SMLSIZE) 
lcd.drawText(1, 56, "0 = immediat" , SMLSIZE) 
end  

if rot == 9 then -- PAGE 7	  
	lcd.drawText(1, 1, "PAGE 6: configuration 2                   " , 0+INVERS) -- TITRE  
  
  
    lcd.drawText(1, 11, "LIMITEUR DR Bouton" , SMLSIZE+INVERS) -- texte fond noir
lcd.drawText(lcd.getLastPos(), 11, " Limiteur" , SMLSIZE) 
lcd.drawText(1, 20, "Dual Rate Th par bouton ou" , SMLSIZE) 
lcd.drawText(1, 29, "sur toute la course Th" , SMLSIZE) 
    lcd.drawText(1, 38, "Courbe St" , SMLSIZE+INVERS) -- texte fond noir
	  lcd.drawText(lcd.getLastPos()+5, 38, "Linearity" , SMLSIZE+INVERS) -- texte fond noir
lcd.drawText(lcd.getLastPos(), 38, " Fin de" , SMLSIZE) 
lcd.drawText(1, 47, "courbe St" , SMLSIZE) 
lcd.drawText(lcd.getLastPos()+4, 47, "Prec. Neutre" , SMLSIZE+INVERS) -- texte fond noir
lcd.drawText(lcd.getLastPos(), 47, " Debut" , SMLSIZE) 
lcd.drawText(1, 56, "de courbe St", SMLSIZE) 
end  

if rot == 10 then -- PAGE 8	  
	lcd.drawText(1, 1, "NOTE: parametre MDL                   " , 0+INVERS) -- TITRE  
  
  
    lcd.drawText(1, 11, "Curve 3:St" , SMLSIZE+INVERS) -- texte fond noir
lcd.drawText(lcd.getLastPos(), 11, " Pour corriger non" , SMLSIZE) 
lcd.drawText(1, 20, "linearite du palonnier servo" , SMLSIZE) 

    lcd.drawText(1, 29, "Numero" , SMLSIZE+INVERS) -- texte fond noir
lcd.drawText(lcd.getLastPos(), 29, " Debut nom de model" , SMLSIZE) 
lcd.drawText(3, 38, "= numero fichier log et mem" , SMLSIZE)

    lcd.drawText(1, 47, "Drive mode" , SMLSIZE+INVERS) -- texte fond noir
lcd.drawText(lcd.getLastPos(), 47, " a renommer pour" , SMLSIZE) 
lcd.drawText(1, 56, "chaque model" , SMLSIZE) 
end  


  
  
  -- page:
lcd.drawNumber(123, 56,"7", 0+INVERS) -- texte numero page

end