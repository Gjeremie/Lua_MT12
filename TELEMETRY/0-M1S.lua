local shared = ...

 local num = model.getInfo().name
local delai = 120 -- delai demarrage 1 sec
local start = getTime()

function shared.run(event)
  lcd.clear()



---- touche bascule entre ecran -----------------

if shared.strt == 1 then -- si pas demarrage telco 

 if event == EVT_VIRTUAL_MENU    then -- bouton menu 
    shared.changeScreen(2)
  end

lcd.drawText(1, 24, "     ACCUEIL      " , DBLSIZE+INVERS) -- TITRE



else -- si premier demarrage telco

 if  getTime()  > delai + start   then -- bouton menu 
    shared.strt = 1
	shared.changeScreen(2)
  end

-- fond noir
lcd.drawFilledRectangle(0, 23, 128,17, SOLID)
lcd.drawPoint(0,23)
lcd.drawPoint(0,39)
lcd.drawPoint(127,23)
lcd.drawPoint(127,39)


-- fond
lcd.drawPoint(27,25)
lcd.drawPoint(44,25)
lcd.drawPoint(49,25)
lcd.drawPoint(60,25)
lcd.drawPoint(71,25)
lcd.drawLine(71,26,72,26, SOLID, ERASE)
lcd.drawLine(29,29,32,29, SOLID, ERASE)
lcd.drawLine(62,29,65,29, SOLID, ERASE)
lcd.drawPoint(75,29)
lcd.drawLine(71,32,72,32, SOLID, ERASE)
lcd.drawPoint(27,33)
lcd.drawPoint(44,33)
lcd.drawPoint(49,33)
lcd.drawPoint(60,33)
lcd.drawPoint(71,33)
lcd.drawLine(39,28,39,32, SOLID, ERASE)
lcd.drawLine(54,29,54,32, SOLID, ERASE)
lcd.drawLine(55,29,55,33, SOLID, ERASE)
lcd.drawLine(56,29,56,32, SOLID, ERASE)
lcd.drawLine(70,24,70,26, SOLID, ERASE)
lcd.drawLine(70,32,70,34, SOLID, ERASE)
lcd.drawLine(74,28,74,30, SOLID, ERASE)
lcd.drawLine(84,26,84,34, SOLID, ERASE)
lcd.drawLine(90,24,90,25, SOLID, ERASE)
lcd.drawLine(90,33,90,34, SOLID, ERASE)
lcd.drawLine(91,24,91,26, SOLID, ERASE)
lcd.drawLine(91,32,91,34, SOLID, ERASE)
lcd.drawLine(92,24,92,28, SOLID, ERASE)
lcd.drawLine(92,30,92,34, SOLID, ERASE)
lcd.drawLine(93,26,93,32, SOLID, ERASE)
lcd.drawLine(94,28,94,30, SOLID, ERASE)
lcd.drawLine(95,26,95,32, SOLID, ERASE)
lcd.drawLine(96,24,96,28, SOLID, ERASE)
lcd.drawLine(96,30,96,34, SOLID, ERASE)
lcd.drawLine(97,24,97,26, SOLID, ERASE)
lcd.drawLine(97,32,97,34, SOLID, ERASE)
lcd.drawLine(98,24,98,25, SOLID, ERASE)
lcd.drawLine(98,33,98,34, SOLID, ERASE)


-- dessin manuel

lcd.drawFilledRectangle(70, 27, 4, 5, ERASE)
lcd.drawRectangle(79, 24, 9, 2, ERASE)
lcd.drawRectangle(28, 24, 7, 2, ERASE)
lcd.drawRectangle(28, 33, 7, 2, ERASE)
lcd.drawRectangle(37, 24, 7, 2, ERASE)
lcd.drawRectangle(50, 24, 7, 2, ERASE)
lcd.drawRectangle(37, 33, 7, 2, ERASE)
lcd.drawRectangle(61, 24, 7, 2, ERASE)
lcd.drawRectangle(61, 33, 7, 2, ERASE)
lcd.drawRectangle(50, 33, 5, 2, ERASE)
lcd.drawRectangle(37, 28, 2, 5, ERASE)
lcd.drawRectangle(82, 26, 2, 9, ERASE)
lcd.drawFilledRectangle(26, 26, 3, 7, ERASE)
lcd.drawFilledRectangle(43, 26, 3, 7, ERASE)
lcd.drawFilledRectangle(48, 26, 3, 7, ERASE)
lcd.drawFilledRectangle(59, 26, 3, 7, ERASE)




	lcd.drawRectangle(26, 37, 42, 2, ERASE) 




end


 
lcd.drawText(1, 44, num , MIDSIZE) -- model



end