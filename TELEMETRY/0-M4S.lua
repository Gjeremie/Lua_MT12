local shared = ...

  local num = model.getInfo().name
  
  

  
function shared.run(event)
  lcd.clear()



---- touche bascule entre ecran -----------------
 if event == EVT_VIRTUAL_MENU then -- bouton menu 
    shared.changeScreen(6)
  end
  

lcd.drawText(1, 24, "     CONFIG             " , DBLSIZE+INVERS) -- TITRE
lcd.drawText(1, 44, num , MIDSIZE) -- model



end