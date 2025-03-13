local shared = ...

  
  
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
 playTone(1200, 120,5) -- play tone
    shared.changeScreen(10)

	end
	


  
  
  
  

  
  
  --- fond -----

  lcd.drawLine(56,1,82,1, SOLID, FORCE)
lcd.drawLine(54,2,55,2, SOLID, FORCE)
lcd.drawPoint(83,2)
lcd.drawLine(52,3,53,3, SOLID, FORCE)
lcd.drawLine(56,3,82,3, SOLID, FORCE)
lcd.drawPoint(2,4)
lcd.drawLine(50,4,51,4, SOLID, FORCE)
lcd.drawLine(1,5,3,5, SOLID, FORCE)

lcd.drawPoint(125,5)
lcd.drawLine(0,6,4,6, SOLID, FORCE)

lcd.drawLine(123,6,124,6, SOLID, FORCE)
lcd.drawLine(76,7,86,7, SOLID, FORCE)
lcd.drawLine(122,7,127,7, SOLID, FORCE)
lcd.drawLine(37,8,51,8, SOLID, FORCE)
lcd.drawPoint(75,8)
lcd.drawLine(53,9,55,9, SOLID, FORCE)
lcd.drawLine(71,9,73,9, SOLID, FORCE)
lcd.drawLine(116,9,121,9, SOLID, FORCE)
lcd.drawLine(38,10,39,10, SOLID, FORCE)
lcd.drawLine(53,10,56,10, SOLID, FORCE)
lcd.drawLine(60,10,66,10, SOLID, FORCE)
lcd.drawLine(70,10,73,10, SOLID, FORCE)
lcd.drawLine(53,11,57,11, SOLID, FORCE)
lcd.drawPoint(59,11)
lcd.drawPoint(67,11)
lcd.drawLine(69,11,73,11, SOLID, FORCE)
lcd.drawLine(1,12,9,12, SOLID, FORCE)
lcd.drawLine(44,12,46,12, SOLID, FORCE)
lcd.drawLine(54,12,58,12, SOLID, FORCE)
lcd.drawLine(68,12,72,12, SOLID, FORCE)
lcd.drawLine(78,12,80,12, SOLID, FORCE)
lcd.drawLine(118,12,119,12, SOLID, FORCE)
lcd.drawLine(43,13,47,13, SOLID, FORCE)
lcd.drawLine(55,13,56,13, SOLID, FORCE)
lcd.drawLine(70,13,71,13, SOLID, FORCE)
lcd.drawLine(77,13,81,13, SOLID, FORCE)
lcd.drawLine(117,13,120,13, SOLID, FORCE)
lcd.drawLine(7,14,8,14, SOLID, FORCE)
lcd.drawLine(33,14,41,14, SOLID, FORCE)
lcd.drawLine(43,14,44,14, SOLID, FORCE)
lcd.drawLine(46,14,47,14, SOLID, FORCE)
lcd.drawPoint(56,14)
lcd.drawPoint(70,14)
lcd.drawLine(77,14,78,14, SOLID, FORCE)
lcd.drawLine(80,14,81,14, SOLID, FORCE)
lcd.drawLine(83,14,90,14, SOLID, FORCE)
lcd.drawLine(115,14,116,14, SOLID, FORCE)
lcd.drawLine(121,14,122,14, SOLID, FORCE)
lcd.drawLine(6,15,9,15, SOLID, FORCE)
lcd.drawLine(43,15,47,15, SOLID, FORCE)
lcd.drawPoint(55,15)
lcd.drawPoint(71,15)
lcd.drawLine(77,15,81,15, SOLID, FORCE)
lcd.drawPoint(115,15)
lcd.drawPoint(122,15)
lcd.drawLine(44,16,46,16, SOLID, FORCE)
lcd.drawLine(78,16,80,16, SOLID, FORCE)
lcd.drawLine(116,16,121,16, SOLID, FORCE)
lcd.drawPoint(0,19)
lcd.drawPoint(63,19)
lcd.drawPoint(38,20)
lcd.drawPoint(83,20)
lcd.drawLine(39,21,46,21, SOLID, FORCE)
lcd.drawLine(75,21,82,21, SOLID, FORCE)
lcd.drawPoint(47,22)
lcd.drawPoint(55,23)
lcd.drawPoint(56,24)
lcd.drawLine(61,24,65,24, SOLID, FORCE)
lcd.drawLine(67,24,86,24, SOLID, FORCE)
lcd.drawLine(55,25,56,25, SOLID, FORCE)
lcd.drawLine(61,25,65,25, SOLID, FORCE)
lcd.drawLine(54,26,58,26, SOLID, FORCE)
lcd.drawLine(62,26,64,26, SOLID, FORCE)
lcd.drawLine(68,26,72,26, SOLID, FORCE)
lcd.drawLine(39,27,51,27, SOLID, FORCE)
lcd.drawLine(53,27,57,27, SOLID, FORCE)
lcd.drawPoint(59,27)
lcd.drawPoint(67,27)
lcd.drawLine(69,27,73,27, SOLID, FORCE)

lcd.drawLine(53,28,56,28, SOLID, FORCE)
lcd.drawLine(60,28,66,28, SOLID, FORCE)
lcd.drawLine(70,28,73,28, SOLID, FORCE)

lcd.drawPoint(48,29)
lcd.drawLine(53,29,55,29, SOLID, FORCE)
lcd.drawLine(71,29,73,29, SOLID, FORCE)
lcd.drawLine(75,30,85,30, SOLID, FORCE)




lcd.drawLine(50,34,52,34, SOLID, FORCE)


lcd.drawLine(36,35,47,35, SOLID, FORCE)
lcd.drawLine(49,35,53,35, SOLID, FORCE)
lcd.drawPoint(64,35)
lcd.drawLine(50,36,52,36, SOLID, FORCE)
lcd.drawLine(65,36,68,36, SOLID, FORCE)
lcd.drawPoint(44,37)

lcd.drawLine(6,41,9,41, SOLID, FORCE)
lcd.drawPoint(5,42)
lcd.drawPoint(10,42)
lcd.drawPoint(7,43)
lcd.drawLine(33,43,45,43, SOLID, FORCE)
lcd.drawLine(7,44,9,44, SOLID, FORCE)
lcd.drawPoint(40,45)
lcd.drawPoint(5,46)
lcd.drawPoint(10,46)
lcd.drawLine(102,46,103,46, SOLID, FORCE)
lcd.drawLine(6,47,9,47, SOLID, FORCE)
lcd.drawLine(100,47,101,47, SOLID, FORCE)
lcd.drawLine(60,49,70,49, SOLID, FORCE)
lcd.drawLine(101,49,102,49, SOLID, FORCE)
lcd.drawPoint(59,50)
lcd.drawPoint(58,51)
lcd.drawLine(101,51,102,51, SOLID, FORCE)
lcd.drawPoint(57,52)
lcd.drawLine(51,53,53,53, SOLID, FORCE)
lcd.drawPoint(56,53)
lcd.drawLine(59,53,66,53, SOLID, FORCE)
lcd.drawLine(100,53,103,53, SOLID, FORCE)
lcd.drawPoint(55,54)
lcd.drawPoint(67,54)
lcd.drawLine(105,55,108,55, SOLID, FORCE)
lcd.drawLine(31,56,33,56, SOLID, FORCE)
lcd.drawPoint(53,56)
lcd.drawPoint(62,56)
lcd.drawPoint(104,56)
lcd.drawPoint(109,56)
lcd.drawLine(66,58,75,58, SOLID, FORCE)
lcd.drawPoint(104,61)
lcd.drawPoint(109,61)
lcd.drawPoint(38,62)
lcd.drawPoint(67,62)
lcd.drawLine(105,62,108,62, SOLID, FORCE)
lcd.drawLine(39,63,66,63, SOLID, FORCE)
lcd.drawLine(0,25,0,28, SOLID, FORCE)
lcd.drawLine(1,18,1,19, SOLID, FORCE)
lcd.drawLine(1,25,1,28, SOLID, FORCE)
lcd.drawLine(2,16,2,19, SOLID, FORCE)
lcd.drawLine(3,13,3,19, SOLID, FORCE)
lcd.drawLine(3,25,3,28, SOLID, FORCE)
lcd.drawLine(4,13,4,19, SOLID, FORCE)
lcd.drawLine(4,25,4,28, SOLID, FORCE)
lcd.drawLine(4,43,4,45, SOLID, FORCE)
lcd.drawLine(5,23,5,30, SOLID, FORCE)
lcd.drawLine(6,24,6,29, SOLID, FORCE)
lcd.drawLine(7,16,7,19, SOLID, FORCE)
lcd.drawLine(7,25,7,28, SOLID, FORCE)
lcd.drawLine(8,16,8,19, SOLID, FORCE)
lcd.drawLine(8,26,8,27, SOLID, FORCE)

lcd.drawLine(0,32,0,38, SOLID, FORCE)
lcd.drawLine(1,35,1,38, SOLID, FORCE)
lcd.drawLine(2,37,2,38, SOLID, FORCE)

lcd.drawLine(11,43,11,45, SOLID, FORCE)
lcd.drawLine(35,55,35,58, SOLID, FORCE)
lcd.drawLine(36,54,36,59, SOLID, FORCE)
lcd.drawLine(37,11,37,12, SOLID, FORCE)
lcd.drawLine(37,16,37,19, SOLID, FORCE)
lcd.drawLine(37,50,37,61, SOLID, FORCE)
lcd.drawLine(38,48,38,49, SOLID, FORCE)
lcd.drawLine(39,46,39,47, SOLID, FORCE)
lcd.drawLine(42,40,42,41, SOLID, FORCE)
lcd.drawLine(43,38,43,39, SOLID, FORCE)
lcd.drawLine(46,32,46,33, SOLID, FORCE)
lcd.drawLine(47,30,47,31, SOLID, FORCE)
lcd.drawLine(47,42,47,44, SOLID, FORCE)
lcd.drawLine(48,23,48,25, SOLID, FORCE)
lcd.drawLine(48,41,48,45, SOLID, FORCE)
lcd.drawLine(49,42,49,44, SOLID, FORCE)
lcd.drawLine(50,51,50,53, SOLID, FORCE)
lcd.drawLine(51,49,51,50, SOLID, FORCE)
lcd.drawLine(51,57,51,59, SOLID, FORCE)
lcd.drawLine(52,47,52,48, SOLID, FORCE)
lcd.drawLine(52,56,52,60, SOLID, FORCE)
lcd.drawLine(53,45,53,46, SOLID, FORCE)
lcd.drawLine(53,59,53,60, SOLID, FORCE)
lcd.drawLine(54,16,54,22, SOLID, FORCE)
lcd.drawLine(54,43,54,44, SOLID, FORCE)
lcd.drawLine(54,56,54,60, SOLID, FORCE)
lcd.drawLine(55,41,55,42, SOLID, FORCE)
lcd.drawLine(55,57,55,59, SOLID, FORCE)
lcd.drawLine(56,39,56,40, SOLID, FORCE)
lcd.drawLine(57,37,57,38, SOLID, FORCE)
lcd.drawLine(58,35,58,36, SOLID, FORCE)
lcd.drawLine(59,31,59,34, SOLID, FORCE)
lcd.drawLine(60,57,60,59, SOLID, FORCE)
lcd.drawLine(61,56,61,60, SOLID, FORCE)
lcd.drawLine(62,31,62,33, SOLID, FORCE)
lcd.drawLine(62,59,62,60, SOLID, FORCE)
lcd.drawLine(63,29,63,33, SOLID, FORCE)
lcd.drawLine(63,56,63,60, SOLID, FORCE)
lcd.drawLine(64,31,64,33, SOLID, FORCE)
lcd.drawLine(64,57,64,59, SOLID, FORCE)
lcd.drawLine(68,55,68,56, SOLID, FORCE)
lcd.drawLine(68,60,68,61, SOLID, FORCE)
lcd.drawLine(72,16,72,22, SOLID, FORCE)
lcd.drawLine(84,3,84,5, SOLID, FORCE)
lcd.drawLine(84,9,84,12, SOLID, FORCE)
lcd.drawLine(84,16,84,19, SOLID, FORCE)
lcd.drawLine(99,47,99,53, SOLID, FORCE)
lcd.drawLine(103,57,103,60, SOLID, FORCE)
lcd.drawLine(104,46,104,53, SOLID, FORCE)
lcd.drawLine(106,56,106,58, SOLID, FORCE)
lcd.drawLine(107,56,107,58, SOLID, FORCE)
lcd.drawLine(110,57,110,60, SOLID, FORCE)
lcd.drawLine(114,12,114,14, SOLID, FORCE)
lcd.drawLine(115,10,115,11, SOLID, FORCE)

lcd.drawLine(121,0,121,7, SOLID, FORCE)
lcd.drawLine(122,10,122,11, SOLID, FORCE)
lcd.drawLine(123,12,123,14, SOLID, FORCE)
lcd.drawLine(126,3,126,4, SOLID, FORCE)
lcd.drawLine(127,0,127,2, SOLID, FORCE)


lcd.drawPoint(127,27)
lcd.drawLine(124,28,126,28, SOLID, FORCE)
lcd.drawPoint(125,32)
lcd.drawPoint(127,32)
lcd.drawLine(120,36,122,36, SOLID, FORCE)
lcd.drawLine(123,29,123,35, SOLID, FORCE)
lcd.drawLine(126,31,126,35, SOLID, FORCE)


  


  ----- texte ------
  
  lcd.drawText(6, 2, "ST.mod" , SMLSIZE) -- texte 
  lcd.drawText(34, 2, "TRM" , SMLSIZE+INVERS) -- texte fond noir
  
    lcd.drawText(12,13, "TH" , SMLSIZE) -- texte 
  lcd.drawText(24, 13, "DR" , SMLSIZE+INVERS) -- texte fond noir

    lcd.drawText(10, 23, "TH" , SMLSIZE) -- texte 
  lcd.drawText(23, 23, "MOD" , SMLSIZE+INVERS) -- texte fond noir
  
  lcd.drawText(87, 19, "Sw TH DR" , SMLSIZE+INVERS) -- texte fond noir
  
      lcd.drawText(4, 32, "BR" , SMLSIZE) -- texte 
	  lcd.drawPoint(14,37)
	  lcd.drawText(16, 32, "Abs" , SMLSIZE) -- texte 
  lcd.drawText(32, 32, "DR" , SMLSIZE+INVERS) -- texte fond noir
  
    lcd.drawText(18, 41, "LAP" , SMLSIZE+INVERS) -- texte fond noir
  
      lcd.drawText(0, 49, "Strt T2" , SMLSIZE) -- texte 
  
  
      lcd.drawText(1, 57, "VOLUME" , SMLSIZE+INVERS) -- texte fond noir
  
  
  
        lcd.drawText(88, 1, "MOD" , SMLSIZE+INVERS) -- texte fond noir
  lcd.drawText(110, 1, "ST" , SMLSIZE) -- texte 
  
          lcd.drawText(91, 10, "DR" , SMLSIZE+INVERS) -- texte fond noir
  lcd.drawText(103, 10, "ST" , SMLSIZE) -- texte 
  
            lcd.drawText(78, 28, "MOD" , SMLSIZE+INVERS) -- texte fond noir
  lcd.drawText(95, 28, "BR.Drg" , SMLSIZE) -- texte 
  
      
  
              lcd.drawText(70, 37, "3POS" , SMLSIZE+INVERS) -- texte fond noir
  lcd.drawText(94, 37, "SA" , SMLSIZE) -- texte 
  
  
         lcd.drawText(72, 47, "BANK" , SMLSIZE+INVERS) -- texte fond noir
  
      lcd.drawText(77, 56, "SA-R" , SMLSIZE+INVERS) -- texte fond noir
  
  
  -- page:
lcd.drawNumber(123, 56,"7", 0+INVERS) -- texte numero page

end