local shared = ...


local rot = 1 -- numero item a modifier (commande par rotary)
local modif = 0 --   =0 si pas mode modif et =valeur de rot si modif de cet item 
local rebound = 0 -- anti rebond Enter key
local valeur = 0 -- valeur en cour de modif
local G4 --  valeur  g4 expo de 0 a 100
local maxdrg -- valeur max agresivité drag brake
  local ecar
  
 local function case(x,y,coche) -- coche : 0= rien 1=cocher 2=rien noir 3=coche noir

lcd.drawRectangle(x, y, 8, 8, SOLID)

if coche == 1 then
lcd.drawLine(x+1,y+1,x+6,y+6, SOLID, FORCE)
lcd.drawLine(x+1,y+6,x+6,y+1, SOLID, FORCE)
elseif coche == 2 then
lcd.drawFilledRectangle(x+1, y+1, 6, 6, FORCE)
elseif coche == 3 then
lcd.drawFilledRectangle(x+1, y+1, 6, 6, FORCE)
lcd.drawLine(x+1,y+1,x+6,y+6, SOLID, ERASE)
lcd.drawLine(x+1,y+6,x+6,y+1, SOLID, ERASE)
end
end
  

 local function cadre(x,y,sel,pt,n1,n2) -- sel : 0= rect noire 1=cadre selection point
										-- pt : valeur point a afficher         n1 et n2  :  affichage point n1/n2 

	if sel == 0 then 
	
	lcd.drawLine(x-1,y-1,x+1,y-1, SOLID, FORCE)
	lcd.drawLine(x-1,y,x+1,y, SOLID, FORCE)
	lcd.drawLine(x-1,y+1,x+1,y+1, SOLID, FORCE)
	
	 else
	lcd.drawRectangle(x-2, y-2, 5, 5, SOLID)
	end

lcd.drawText(85, 29, "Point " .. n1 .. "/" .. n2, SMLSIZE) -- point n1 sur n2
lcd.drawText(85, 38, pt , SMLSIZE) -- valeur point pt
end  

  
function choose(val,mi,ma,int) -- fonction bouton rotary next ou prev avec intervalle de changement et min et max 
	val = val+int 
	if int>0  then
	
		if val>ma then
		val=ma
		else
		playTone(1200, 50,5) -- play tone
		end
	
	else
		if val<mi then
		val=mi
		else
		playTone(1200, 50,5) -- play tone
		end
	end
		
return val
end  
  
  
  
function shared.run(event)
  lcd.clear()



---- touche bascule entre ecran -----------------
 if event == EVT_VIRTUAL_MENU then -- bouton menu 
 playTone(1200, 120,5) -- play tone
    shared.changeScreen(8)
  end
  
 if event == EVT_VIRTUAL_MENU_LONG then -- bouton menu 
 playTone(1200, 120,5) -- play tone
    shared.changeScreen(1)
  end
    
lcd.drawText(1, 1, "CONFIGURATION                   " , 0+INVERS) -- TITRE
  
 G4 = getValue('gvar4')  -- valeur  g4 de 0 a 70
  

--- code -----
if (modif == 0) then -- si mode choix item ====================
	if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
    rot = rot+1 -- allez item suivant
	playTone(1200, 50,5) -- play tone
		if (rot >30) then -- max item
		rot =1
		end
	end
	if event == EVT_VIRTUAL_PREV then -- bouton rotary  prev
    rot = rot-1
	playTone(1200, 50,5) -- play tone
		if (rot <1) then
		rot =30     --   max item
		end
	end
	if ( event == EVT_VIRTUAL_ENTER and (getTime() - rebound) > 150 ) then -- bouton rotary ENTER anti rebond
	playTone(1200, 120,5) -- play tone
		rebound = getTime()
	
	 modif = rot -- assigner num item a modif
	   
	end
else -- si mode modif ====================

	if ( event == EVT_VIRTUAL_ENTER and (getTime() - rebound) > 150 ) then -- bouton rotary ENTER anti rebond
	playTone(1200, 120,5) -- play tone
	rebound = getTime()
	modif = 0 -- revenir a mode choix item
	end	
end


if (rot <9) then --========================    PAGE 1    ======================

  --========================= affiche texte fond =================================
lcd.drawText(1, 11, "Tx V. Alert:" , SMLSIZE+INVERS) -- texte fond noir
lcd.drawText(1, 20, "Lipo V. Alert:" , SMLSIZE+INVERS) -- texte fond noir  
lcd.drawText(1, 29, "Temp. Alert:" , SMLSIZE+INVERS) -- texte fond noir

lcd.drawText(1, 47, "Fan Speed:" , SMLSIZE+INVERS) -- texte fond noir
 
   
 -- ========================== affiche valeur ========================================

if rot==1 then -------------- VALEUR alerte tension Tx   /   Logic Switch L58  
  
------ affiche valeur selectionnne -----
lcd.drawText(74, 11, model.getLogicalSwitch(57).v2/10 .. " V" , SMLSIZE+INVERS) -- texte fond noir

	if modif == rot then -- si mode modif sur cet item

	local tab = model.getLogicalSwitch(57)
	valeur = tab.v2 -- lire valeur de LS
	
	if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
		valeur = choose(valeur,65,83,1) -- detection rotary next ou prev
	end
	if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
	 valeur = choose(valeur,65,83,-1) -- detection rotary next ou prev
	end
	
	tab.v2 = valeur
	model.setLogicalSwitch(57, tab) -- assigner valeur de LS

	end

else ------ affiche valeur non selectionne -----
lcd.drawText(74, 11, model.getLogicalSwitch(57).v2/10 .. " V" , SMLSIZE) -- texte

end ----------------------- 
 
   
if rot==2 then -------------- ACTIVATION alerte tension Tx   /   Special Function CF15   
  
------ affiche valeur selectionnne -----
case(119,10,model.getCustomFunction(14).active+2) -- case fond noir

	if modif == rot then -- si mode modif sur cet item

	local tab = model.getCustomFunction(14)
	valeur = tab.active -- lire valeur de LS
	
	if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
		valeur = choose(valeur,0,1,1) -- detection rotary next ou prev
	end
	if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
	 valeur = choose(valeur,0,1,-1) -- detection rotary next ou prev
	end
	
	tab.active = valeur
	model.setCustomFunction(14, tab) -- assigner valeur de LS
	end

else ------ affiche valeur non selectionne -----
case(119,10,model.getCustomFunction(14).active) -- case
end ----------------------- 
   
  
   
if rot==3 then -------------- VALEUR alerte lipo    /   Logic Switch L59  
------ affiche valeur selectionnne -----
lcd.drawText(62, 20, math.floor(model.getLogicalSwitch(58).v2/10)/100 .. " V" , SMLSIZE+INVERS) -- texte fond noir

	if modif == rot then -- si mode modif sur cet item

	local tab = model.getLogicalSwitch(58)
	valeur = tab.v2 -- lire valeur de LS
	
	if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
		valeur = choose(valeur,0,4400,50) -- detection rotary next ou prev
	end
	if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
	 valeur = choose(valeur,0,4400,-50) -- detection rotary next ou prev
	end
		
	tab.v2 = valeur
	model.setLogicalSwitch(58, tab) -- assigner valeur de LS

	end

else ------ affiche valeur non selectionne -----
lcd.drawText(62, 20, math.floor(model.getLogicalSwitch(58).v2/10)/100 .. " V" , SMLSIZE) -- texte

end ----------------------- 
  
  
  if rot==4 then -------------- VALEUR DELAY alerte lipo    /   Logic Switch L59  
    lcd.drawText(95, 20, model.getLogicalSwitch(58).delay/10 .. " s" , SMLSIZE+INVERS) -- texte
  
  
  	if modif == rot then -- si mode modif sur cet item

	local tab = model.getLogicalSwitch(58)
	valeur = tab.delay -- lire valeur de LS
	
	if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
		valeur = choose(valeur,0,50,1) -- detection rotary next ou prev
	end
	if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
	 valeur = choose(valeur,0,50,-1) -- detection rotary next ou prev
	end
		
	tab.delay = valeur
	model.setLogicalSwitch(58, tab) -- assigner valeur de LS

	end
  
  else ------ affiche valeur non selectionne -----
  lcd.drawText(95, 20, model.getLogicalSwitch(58).delay/10 .. " s" , SMLSIZE) -- texte
  end
  
   
if rot==5 then -------------- ACTIVATION alerte lipo Tx   /   Special Function CF16   
  
------ affiche valeur selectionnne -----
case(119,19,model.getCustomFunction(15).active+2) -- case fond noir

	if modif == rot then -- si mode modif sur cet item

	local tab = model.getCustomFunction(15)
	valeur = tab.active -- lire valeur de LS
	
	if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
		valeur = choose(valeur,0,1,1) -- detection rotary next ou prev
	end
	if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
	 valeur = choose(valeur,0,1,-1) -- detection rotary next ou prev
	end
	
	tab.active = valeur
	model.setCustomFunction(15, tab) -- assigner valeur de LS

	end

else ------ affiche valeur non selectionne -----
case(119,19,model.getCustomFunction(15).active) -- case

end ----------------------- 
   
  
 if rot==6 then -------------- VALEUR alerte temperature   /   Logic Switch L60  
  
------ affiche valeur selectionnne -----
lcd.drawText(74, 29, model.getLogicalSwitch(59).v2 .. " °C" , SMLSIZE+INVERS) -- texte fond noir

	if modif == rot then -- si mode modif sur cet item

	local tab = model.getLogicalSwitch(59)
	valeur = tab.v2 -- lire valeur de LS
	
	if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
		valeur = choose(valeur,10,99,1) -- detection rotary next ou prev
	end
	if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
	 valeur = choose(valeur,10,99,-1) -- detection rotary next ou prev
	end
		
	tab.v2 = valeur
	model.setLogicalSwitch(59, tab) -- assigner valeur de LS

	end

else ------ affiche valeur non selectionne -----
lcd.drawText(74, 29, model.getLogicalSwitch(59).v2 .. " °C" , SMLSIZE) -- texte

end ----------------------- 
 
   
   
if rot==7 then -------------- ACTIVATION alerte temperature   /   Special Function CF17   
  
------ affiche valeur selectionnne -----
case(119,28,model.getCustomFunction(16).active+2) -- case fond noir

	if modif == rot then -- si mode modif sur cet item

	local tab = model.getCustomFunction(16)
	valeur = tab.active -- lire valeur de LS
	
	if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
			valeur = choose(valeur,0,1,1) -- detection rotary next ou prev
	end
	if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
	 	valeur = choose(valeur,0,1,-1) -- detection rotary next ou prev
	end
	
	tab.active = valeur
	model.setCustomFunction(16, tab) -- assigner valeur de LS

	end

else ------ affiche valeur non selectionne -----
case(119,28,model.getCustomFunction(16).active) -- case

end ----------------------- 
   
 
   
   
if rot==8 then -------------- VALEUR reglage ventilo   /   output 3
  
------ affiche valeur selectionnne -----
if model.getOutput(2).max == 0 then
lcd.drawText(74, 47, "Off" , SMLSIZE+INVERS) -- texte fond noir
else
lcd.drawText(74, 47, math.floor(model.getOutput(2).max/10) .." %" , SMLSIZE+INVERS) -- texte fond noir

end


	if modif == rot then -- si mode modif sur cet item

	local tab = model.getOutput(2)
	valeur = tab.max -- lire valeur de output
	
	if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
		valeur = choose(valeur,0,1000,100) -- detection rotary next ou prev
	end
	if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
	 valeur = choose(valeur,0,1000,-100) -- detection rotary next ou prev
	end	
		
	tab.max = valeur
	model.setOutput(2, tab) -- assigner valeur de output

	end

else ------ affiche valeur non selectionne -----

if model.getOutput(2).max == 0 then
lcd.drawText(74, 47, "Off" , SMLSIZE) -- texte  
else
lcd.drawText(74, 47, math.floor(model.getOutput(2).max/10) .." %" , SMLSIZE) -- texte  

end

end ----------------------- 
   
 
   
elseif (rot >8 and rot<14) then --========================    PAGE 2    ======================  
    
    --========================= affiche texte fond =================================

lcd.drawText(1, 11, "EPA St:" , SMLSIZE+INVERS) -- texte fond noir
	lcd.drawText(45, 11, "-L" , SMLSIZE+INVERS) -- texte fond noir
	lcd.drawText(92, 11, "+R" , SMLSIZE+INVERS) -- texte fond noir
lcd.drawText(1, 20, "Centre St:" , SMLSIZE+INVERS) -- texte fond noir  
lcd.drawText(1, 38, "Thr Speed point %:" , SMLSIZE+INVERS) -- texte fond noir
lcd.drawText(1, 56, "Feeling St:" , SMLSIZE+INVERS) -- texte fond noir

   
 -- ========================== affiche valeur ========================================
   
 if rot==9 then -------------- VALEUR reglage epa direction left   /   output 0 (ch1)
  
------ affiche valeur selectionnne -----
lcd.drawText(59, 11, model.getOutput(0).min  , SMLSIZE+INVERS) -- texte fond noir

	if modif == rot then -- si mode modif sur cet item

	local tab = model.getOutput(0)
	valeur = tab.min -- lire valeur de output
	
	if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
		valeur = choose(valeur,-900,-100,5) -- detection rotary next ou prev
	end
	if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
	 valeur = choose(valeur,-900,-100,-5) -- detection rotary next ou prev
	end
	
	tab.min = valeur
	model.setOutput(0, tab) -- assigner valeur de output

	end

else ------ affiche valeur non selectionne -----
lcd.drawText(59, 11, model.getOutput(0).min  , SMLSIZE) -- texte

end -----------------------   
      
	  
if rot==10 then -------------- VALEUR reglage epa direction right   /   output 0 (ch1)
  
------ affiche valeur selectionnne -----
lcd.drawText(106, 11, model.getOutput(0).max  , SMLSIZE+INVERS) -- texte fond noir

	if modif == rot then -- si mode modif sur cet item

	local tab = model.getOutput(0)
	valeur = tab.max -- lire valeur de output
	
	if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
		valeur = choose(valeur,100,900,5) -- detection rotary next ou prev
	end
	if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
	 valeur = choose(valeur,100,900,-5) -- detection rotary next ou prev
	end

	tab.max = valeur
	model.setOutput(0, tab) -- assigner valeur de output
	end

else ------ affiche valeur non selectionne -----
lcd.drawText(106, 11, model.getOutput(0).max  , SMLSIZE) -- texte

end ----------------------- 
   
 
   	  
if rot==11 then -------------- VALEUR reglage  direction ppm center   /   output 0 (ch1)
  
------ affiche valeur selectionnne -----
lcd.drawText(86, 20, model.getOutput(0).ppmCenter  , SMLSIZE+INVERS) -- texte fond noir

	if modif == rot then -- si mode modif sur cet item

	local tab = model.getOutput(0)
	valeur = tab.ppmCenter -- lire valeur de output
	
	if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
		valeur = choose(valeur,-80,80,1) -- detection rotary next ou prev
	end
	if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
	 valeur = choose(valeur,-80,80,-1) -- detection rotary next ou prev
	end
	
	
	 tab.ppmCenter = valeur
	  model.setOutput(0, tab) -- assigner valeur de output
end

else ------ affiche valeur non selectionne -----
lcd.drawText(86, 20, model.getOutput(0).ppmCenter  , SMLSIZE) -- texte

end ----------------------- 
 
   
   if rot==12 then -------------- VALEUR point speed thr   /   Logic Switch L14 
  
------ affiche valeur selectionnne -----
lcd.drawText(86, 38, model.getLogicalSwitch(13).v2 .. " %" , SMLSIZE+INVERS) -- texte fond noir

	if modif == rot then -- si mode modif sur cet item

	local tab = model.getLogicalSwitch(13)
	valeur = tab.v2 -- lire valeur de LS
	
	if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
		valeur = choose(valeur,5,95,1) -- detection rotary next ou prev
	end
	if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
	 valeur = choose(valeur,5,95,-1) -- detection rotary next ou prev
	end
	
	tab.v2 = valeur
	model.setLogicalSwitch(13, tab) -- assigner valeur de LS

	end

else ------ affiche valeur non selectionne -----
lcd.drawText(86, 38, model.getLogicalSwitch(13).v2 .. " %" , SMLSIZE) -- texte

end ----------------------- 
   
  
if rot==13 then -------------- VALEUR feeling St  Ultra Fast ou Fast ou Medium ou Slow /   channel 10 copier les ligne de mix   
   
   ------ affiche valeur selectionnne -----
   
  if model.getMix(9, 2).speedUp == 0 then
   lcd.drawText(74, 56, "Instant" , SMLSIZE+INVERS) -- texte fond noir
	else
	lcd.drawText(74, 56,model.getMix(9, 2).speedUp/100 .. " s" , SMLSIZE+INVERS) -- texte fond noir
	end
   

    
   	if modif == rot then -- si mode modif sur cet item
	
	
	valeur = model.getMix(9, 2).speedUp
	
	
	if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
			valeur = choose(valeur,0,30,1) -- detection rotary next ou prev
			
			
			model.deleteMix(9, 3) -- suppr ligne 4 de channel 10
			model.deleteMix(9, 2) -- suppr ligne 3 de channel 10
			
			local tab = model.getMix(9, 0) -- copier ligne 1
			 tab.speedUp = valeur -- modif time de ligne copier
			 tab.multiplex = 2
			model.insertMix(9, 2, tab) -- copier une ligne de mix et la coller dans ligne 3
			
			tab = model.getMix(9, 1) -- copier ligne 2
			 tab.speedDown = valeur -- modif time de ligne copier
			 tab.multiplex = 0
			model.insertMix(9, 3, tab) -- copier une ligne de mix et la coller dans ligne 4
			
			
	end
	
	
	if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
	 	valeur = choose(valeur,0,30,-1) -- detection rotary next ou prev
		
			model.deleteMix(9, 3) -- suppr ligne 4 de channel 10
			model.deleteMix(9, 2) -- suppr ligne 3 de channel 10
			
			local tab = model.getMix(9, 0) -- copier ligne 1
			 tab.speedUp = valeur -- modif time de ligne copier
			 tab.multiplex = 2
			model.insertMix(9, 2, tab) -- copier une ligne de mix et la coller dans ligne 3
			
			tab = model.getMix(9, 1) -- copier ligne 2
			 tab.speedDown = valeur -- modif time de ligne copier
			 tab.multiplex = 0
			model.insertMix(9, 3, tab) -- copier une ligne de mix et la coller dans ligne 4
		
	end

		
		

	end
  
   
   else ------ affiche valeur non selectionne -----
   

  if model.getMix(9, 2).speedUp == 0 then
   lcd.drawText(74, 56, "Instant" , SMLSIZE) -- texte
	else
	lcd.drawText(74, 56,model.getMix(9, 2).speedUp/100 .. " s" , SMLSIZE) -- texte
	end


   

   
end
   
   

elseif (rot >13 and rot<20) then --========================    PAGE 3    ======================  
   
    --========================= affiche texte fond =================================

lcd.drawText(1, 11, "ABS:" , SMLSIZE+INVERS) -- texte fond noir

lcd.drawText(22, 11, "Duty cycle" , SMLSIZE+INVERS) -- texte fond noir  
lcd.drawText(1, 20, "Hold" , SMLSIZE+INVERS) -- texte fond noir  
lcd.drawText(62, 20, "Release" , SMLSIZE+INVERS) -- texte fond noir  

lcd.drawText(1, 29, "DRAG Brake:" , SMLSIZE+INVERS) -- texte fond noir
lcd.drawText(58, 29, "Hold" , SMLSIZE+INVERS) -- texte fond noir
lcd.drawText(36, 38, "Rise Time" , SMLSIZE+INVERS) -- texte fond noir

lcd.drawText(1, 47, "LIMITEUR DR Bouton:" , SMLSIZE+INVERS) -- texte fond noir

lcd.drawText(1, 56, "Mode Enfant:" , SMLSIZE+INVERS) -- texte fond noir
   
 -- ========================== affiche valeur ========================================
  
  

  
  
   if rot==14 then -------------- VALEUR reglage duty cycle  ABS  LS20
 lcd.drawText(71, 11, (129+model.getLogicalSwitch(19).v1)/10 .. " s" , SMLSIZE+INVERS) -- texte fond noir
 
 
 if modif == rot then -- si mode modif sur cet item

	local tab = model.getLogicalSwitch(19)
	valeur = tab.v1 -- lire valeur de LS
	
	if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
		valeur = choose(valeur,1-129,5-129,1) -- detection rotary next ou prev
	end
	if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
	 valeur = choose(valeur,1-129,5-129,-1) -- detection rotary next ou prev
	end
		
	tab.v1 = valeur
	tab.v2 = valeur
	model.setLogicalSwitch(19, tab) -- assigner valeur de LS 

		 model.deleteMix(23, 1) -- suppr ligne 2 de channel 24
			tab = model.getMix(23, 0) -- copier ligne 1
			 tab.speedUp = 129+valeur -- modif time de ligne copier
			 tab.speedDown = 129+valeur -- modif time de ligne copier
			 tab.multiplex = 2
		model.insertMix(23, 1, tab) -- copier une ligne de mix et la coller dans ligne 2
		

	end
 
 else ------ affiche valeur non selectionne -----
  lcd.drawText(71, 11, (129+model.getLogicalSwitch(19).v1)/10 .. " s" , SMLSIZE) 
end  
  
  	local tab = model.getCurve(31) -- COURBE abs 32
		local pos = {}
		pos = tab.x -- pos[1]  c'est la valeur x du premier point de la courbe
  
   if rot==15 then -------------- VALEUR reglage hold time ABS curve abs
  lcd.drawText(25, 20, (129+model.getLogicalSwitch(19).v1)/1000*(100+pos[2]) .. " s" , SMLSIZE+INVERS) -- texte fond noir

  if modif == rot then -- si mode modif sur cet item


	

	valeur = pos[2]
	
	if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
		valeur = choose(valeur,-75,-25,2) -- detection rotary next ou prev
	end
	if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
		valeur = choose(valeur,-75,-25,-2) -- detection rotary next ou prev
	end
	
	
		
	pos[2] = valeur  -- POINT 2
	pos[3] = valeur  -- POINT 3
	pos[4] = - valeur  -- POINT 4 sym
	pos[5] = - valeur  -- POINT 5 sym
	tab.x = pos
	model.setCurve(31,tab)  -- COURBE
	
	
	
	

	end
 
 
 else ------ affiche valeur non selectionne -----
   lcd.drawText(25, 20, (129+model.getLogicalSwitch(19).v1)/1000*(100+pos[2]) .. " s" , SMLSIZE) 
end  
  
  
  
  lcd.drawText(99, 20, (129+model.getLogicalSwitch(19).v1)/10-(129+model.getLogicalSwitch(19).v1)/1000*(100+pos[2]) .. " s" , SMLSIZE)  -- affiche realese time abs

  
  
  
  
  
  if rot==16 then -------------- VALEUR Tps drag brake /   channel 19 copier les ligne de mix   
   
   ------ affiche valeur selectionnne -----
  
   lcd.drawText(81, 29,model.getMix(18, 1).speedUp/50 .. " s", SMLSIZE+INVERS) -- texte fond noir
	
      
   	if modif == rot then -- si mode modif sur cet item
		  
		   valeur = model.getMix(18, 1).speedUp -- recup valeur actuelle tps drag brake
	
	
	if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
			valeur = choose(valeur,15,80,5) -- detection rotary next ou prev
			
			model.deleteMix(18, 1) -- suppr ligne 2 de channel 19
			tab = model.getMix(18, 0) -- copier ligne 1
			tab.speedUp = valeur -- modif time de ligne copier
			tab.multiplex = 2
		model.insertMix(18, 1, tab) -- copier une ligne de mix et la coller dans ligne 2
		
		if model.getMix(19, 1).speedUp> valeur/5 then -- si valeur agressive drag brake trop grande
		model.deleteMix(19, 1) -- suppr ligne 2 de channel 20
			tab = model.getMix(19, 0) -- copier ligne 1
			tab.speedUp = math.floor( model.getMix(18, 1).speedUp/5 ) -- modif time de ligne copier
			tab.multiplex = 2
		model.insertMix(19, 1, tab) -- copier une ligne de mix et la coller dans ligne 2
			end
			
	end
	
	
	if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
	 	valeur = choose(valeur,15,80,-5) -- detection rotary next ou prev
		
		model.deleteMix(18, 1) -- suppr ligne 2 de channel 19
			tab = model.getMix(18, 0) -- copier ligne 1
			tab.speedUp = valeur -- modif time de ligne copier
			tab.multiplex = 2
		model.insertMix(18, 1, tab) -- copier une ligne de mix et la coller dans ligne 2
		
			if model.getMix(19, 1).speedUp> valeur/5 then -- si valeur agressive drag brake trop grande
		model.deleteMix(19, 1) -- suppr ligne 2 de channel 20
			tab = model.getMix(19, 0) -- copier ligne 1
			tab.speedUp = math.floor( model.getMix(18, 1).speedUp/5 ) -- modif time de ligne copier
			tab.multiplex = 2
		model.insertMix(19, 1, tab) -- copier une ligne de mix et la coller dans ligne 2
			end
	end

	end
  
   
   else ------ affiche valeur non selectionne -----
   
   lcd.drawText(81, 29,model.getMix(18, 1).speedUp/50 .. " s", SMLSIZE) -- texte fond noir
   
end
  
  
  
  
  
  
  
  
    
  if rot==17 then -------------- VALEUR agressivité drag brake /   channel 20 copier les ligne de mix   
   
   ------ affiche valeur selectionnne -----

   lcd.drawText(81, 38,model.getMix(19, 1).speedUp/10 .. " s", SMLSIZE+INVERS) -- texte  
	
      
   	if modif == rot then -- si mode modif sur cet item
		  
		   
	maxdrg = math.floor( model.getMix(18, 1).speedUp/5 )
	valeur = model.getMix(19, 1).speedUp
	
	
	if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
			valeur = choose(valeur,0,maxdrg,1) -- detection rotary next ou prev
			
		model.deleteMix(19, 1) -- suppr ligne 2 de channel 19
			tab = model.getMix(19, 0) -- copier ligne 1
			tab.speedUp = valeur -- modif time de ligne copier
			tab.multiplex = 2
		model.insertMix(19, 1, tab) -- copier une ligne de mix et la coller dans ligne 2
			
			
	end
	
	
	if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
	 	valeur = choose(valeur,0,maxdrg,-1) -- detection rotary next ou prev
		
		model.deleteMix(19, 1) -- suppr ligne 2 de channel 19
			tab = model.getMix(19, 0) -- copier ligne 1
			tab.speedUp = valeur -- modif time de ligne copier
			tab.multiplex = 2
		model.insertMix(19, 1, tab) -- copier une ligne de mix et la coller dans ligne 2
		
	end

	end
  
   
   else ------ affiche valeur non selectionne -----
 
   lcd.drawText(81, 38,model.getMix(19, 1).speedUp/10 .. " s", SMLSIZE) -- texte  
   
end
  
  
  
  
  
 if rot==18 then -------------- ACTIVATION limiteur DR bouton    /   Special Function CF11  / Logical switch  LS44 
  
------ affiche valeur selectionnne -----
case(94,46,model.getCustomFunction(10).active+2) -- case fond noir

	if modif == rot then -- si mode modif sur cet item

	local tab = model.getCustomFunction(10)
	valeur = tab.active -- lire valeur de LS
	
	if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
		valeur = choose(valeur,0,1,1) -- detection rotary next ou prev
	end
	if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
	 valeur = choose(valeur,0,1,-1) -- detection rotary next ou prev
	end
	
	tab.active = valeur
	model.setCustomFunction(10, tab) -- assigner valeur de LS
	
	local tab = model.getLogicalSwitch(43) -- recup valeur LS44
		
			tab.v2 = model.getCustomFunction(10).active*100
	model.setLogicalSwitch(43, tab) -- assigner valeur de LS44 

	
		
	end

else ------ affiche valeur non selectionne -----
case(94,46,model.getCustomFunction(10).active) -- case
end -----------------------  
  
  
  
  
  
  
   if rot==19 then -------------- VALEUR reglage mode enfant /   output 1 (ch2)
  
------ affiche valeur selectionnne -----

lcd.drawText(97, 56, model.getOutput(1).max  , SMLSIZE+INVERS) -- texte fond noir

if model.getOutput(1).max == 1000 then -- PAS mode enfant
case(86,55,2) -- case fond noir deselect
else
case(86,55,3) -- case fond noir select
end

	if modif == rot then -- si mode modif sur cet item

	local tab = model.getOutput(1)
	valeur = tab.max -- lire valeur de output
	
	if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
		valeur = choose(valeur,100,1000,50) -- detection rotary next ou prev
	end
	if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
	 valeur = choose(valeur,100,1000,-50) -- detection rotary next ou prev
	end
		
	tab.max = valeur
	model.setOutput(1, tab) -- assigner valeur de output

	end

else ------ affiche valeur non selectionne -----

if model.getOutput(1).max == 1000 then -- PAS mode enfant
case(86,55,0) -- case   deselect
else
case(86,55,1) -- case   select
end

lcd.drawText(97, 56, model.getOutput(1).max  , SMLSIZE) -- texte

end ----------------------- 

elseif (rot >19 and rot<26) then -- rot= 15 16 17 18  ========================    PAGE 4    ======================  

-- AXEs de  Courbe Th
lcd.drawText(86, 11, "Courbe Th" , SMLSIZE+INVERS) -- gaz
lcd.drawLine(15,61,66,61, SOLID, FORCE)
lcd.drawLine(17,12,17,60, SOLID, FORCE)
lcd.drawLine(17,62,17,63, SOLID, FORCE)
-- Point Zero a 17,61

local tab = model.getCurve(3) -- COURBE gaz 3
local point = {}
local pos = {}
point = tab.y  -- point[1]  c'est la valeur y du premier point de la courbe
pos = tab.x


if rot == 20 then -- ROT point 3 de courbe

	if modif == rot then -- si selectionné
	valeur =  point[3] -- POINT 3
	
	if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
		valeur = choose(valeur,0,100,1) -- detection rotary next ou prev
	end
	if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
	 valeur = choose(valeur,0,100,-1) -- detection rotary next ou prev
	end
		
	point[3] = valeur  -- POINT 3
	tab.y = point
	model.setCurve(3,tab)  -- COURBE gaz 3
		
	cadre(17+pos[3]/2,61-point[3]/2,1,point[3],1,6) -- dessin POINT 3   -   PT 1/6
	
	else -- si pas selectionné
	cadre(17+pos[3]/2,61-point[3]/2,0,point[3],1,6)   -- dessin POINT 3   -   PT 1/6
	end
end

if rot == 21 then -- ROT point 4 de courbe

	if modif == rot then -- si selectionné
	valeur =  point[4] -- POINT 4
	
	if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
		valeur = choose(valeur,0,100,1) -- detection rotary next ou prev
	end
	if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
	 valeur = choose(valeur,0,100,-1) -- detection rotary next ou prev
	end
		
	point[4] = valeur  -- POINT 4
	tab.y = point
	model.setCurve(3,tab)  -- COURBE gaz 3
		
	cadre(17+pos[4]/2,61-point[4]/2,1,point[4],2,6) -- dessin POINT 4   -   PT 2/6
	
	else -- si pas selectionné
	cadre(17+pos[4]/2,61-point[4]/2,0,point[4],2,6)   -- dessin POINT 4   -   PT 2/6
	end
end

if rot == 22 then -- ROT point 5 de courbe

	if modif == rot then -- si selectionné
	valeur =  point[5] -- POINT 5
	
	if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
		valeur = choose(valeur,0,100,1) -- detection rotary next ou prev
	end
	if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
	 valeur = choose(valeur,0,100,-1) -- detection rotary next ou prev
	end
			
	point[5] = valeur  -- POINT 5
	tab.y = point
	model.setCurve(3,tab)  -- COURBE gaz 3
		
	cadre(17+pos[5]/2,61-point[5]/2,1,point[5],3,6) -- dessin POINT 5   -   PT 3/6
	
	else -- si pas selectionné
	cadre(17+pos[5]/2,61-point[5]/2,0,point[5],3,6)   -- dessin POINT 5   -   PT 3/6
	end
end

if rot == 23 then -- ROT point 6 de courbe

	if modif == rot then -- si selectionné
	valeur =  point[6] -- POINT 6
	
	if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
		valeur = choose(valeur,0,100,1) -- detection rotary next ou prev
	end
	if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
	 valeur = choose(valeur,0,100,-1) -- detection rotary next ou prev
	end
		
	point[6] = valeur  -- POINT 6
	tab.y = point
	model.setCurve(3,tab)  -- COURBE gaz 3
		
	cadre(17+pos[6]/2,61-point[6]/2,1,point[6],4,6) -- dessin POINT 6   -   PT 4/6
	
	else -- si pas selectionné
	cadre(17+pos[6]/2,61-point[6]/2,0,point[6],4,6)   -- dessin POINT 6   -   PT 4/6
	end
end

if rot == 24 then -- ROT point 7 de courbe

	if modif == rot then -- si selectionné
	valeur =  point[7] -- POINT 7
	
	if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
		valeur = choose(valeur,0,100,1) -- detection rotary next ou prev
	end
	if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
	 valeur = choose(valeur,0,100,-1) -- detection rotary next ou prev
	end
		
	point[7] = valeur  -- POINT 7
	tab.y = point
	model.setCurve(3,tab)  -- COURBE gaz 3
		
	cadre(17+pos[7]/2,61-point[7]/2,1,point[7],5,6) -- dessin POINT 7   -   PT 5/6
	
	else -- si pas selectionné
	cadre(17+pos[7]/2,61-point[7]/2,0,point[7],5,6)   -- dessin POINT 7   -   PT 5/6
	end
end

if rot == 25 then -- ROT point 8 de courbe

	if modif == rot then -- si selectionné
	valeur =  point[8] -- POINT 8
	
	if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
		valeur = choose(valeur,0,100,1) -- detection rotary next ou prev
	end
	if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
	 valeur = choose(valeur,0,100,-1) -- detection rotary next ou prev
	end
		
	point[8] = valeur  -- POINT 8
	tab.y = point
	model.setCurve(3,tab)  -- COURBE gaz 3
		
	cadre(17+pos[8]/2,61-point[8]/2,1,point[8],6,6) -- dessin POINT 8   -   PT 6/6
	
	else -- si pas selectionné
	cadre(17+pos[8]/2,61-point[8]/2,0,point[8],6,6)   -- dessin POINT 8   -   PT 6/6
	end
end





  	
	-- Tracer courbe :
lcd.drawLine(17,61,17+pos[3]/2,61-point[3]/2, SOLID, FORCE)

for i = 3 , 7 , 1 do
lcd.drawLine(17+pos[i]/2,61-point[i]/2,17+pos[i+1]/2,61-point[i+1]/2, SOLID, FORCE)
end

lcd.drawLine(17+pos[8]/2,61-point[8]/2,17+50,61-50, SOLID, FORCE)

	-- Tracer valeur live gaz :
if getValue('input31') >0 then   -- valeur  input 31 (gaz) sur 100
	lcd.drawLine(17+(getValue('input31')/10.24 )/2,61+1,17+(getValue('input31')/10.24 )/2,61+2, SOLID, FORCE)    
	lcd.drawText(70, 58, math.floor(getValue('input31')/10.24), SMLSIZE) 
	else
	lcd.drawText(70, 58, "0", SMLSIZE) 
end

if getValue('ch2') >0 then   -- valeur  ch2 (gaz) sur 100
	lcd.drawLine(17-2,61-(getValue('ch2')/10.24)/2,17-1,61-(getValue('ch2')/10.24)/2, SOLID, FORCE)    
	lcd.drawText(0, 11, math.floor(getValue('ch2')/10.24), SMLSIZE) 
	else
		lcd.drawText(0, 11, "0", SMLSIZE) 
end
   
--  ========================   FIN  PAGE 4    ======================  
   
elseif (rot >25 and rot<29) then -- rot= 21 22 23  ========================    PAGE 5    ======================     
   
-- AXEs de  Courbe br
lcd.drawText(85, 11, "Courbe Br" , SMLSIZE+INVERS) -- brake
lcd.drawLine(17,13,68,13, SOLID, FORCE)
lcd.drawLine(66,11,66,12, SOLID, FORCE)
lcd.drawLine(66,14,66,62, SOLID, FORCE)
-- Point Zero a 66,13

local tab = model.getCurve(0) -- COURBE br 0
local point = {}
local pos = {}
point = tab.y  -- point[1]  c'est la valeur y du premier point de la courbe
pos = tab.x   

if rot == 26 then -- ROT point 5 de courbe

	if modif == rot then -- si selectionné
	valeur =  point[5] -- POINT 5
	
	if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
		valeur = choose(valeur,-100,0,1) -- detection rotary next ou prev
	end
	if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
	 valeur = choose(valeur,-100,0,-1) -- detection rotary next ou prev
	end
		
	point[5] = valeur  -- POINT 5
	tab.y = point
	model.setCurve(0,tab)  -- COURBE br 0
		
	cadre(66+pos[5]/2,13-point[5]/2,1,point[5],1,3) -- dessin POINT 5   -   PT 1/3
	
	else -- si pas selectionné
	cadre(66+pos[5]/2,13-point[5]/2,0,point[5],1,3)   -- dessin POINT 5   -   PT 1/3
	end
end

if rot == 27 then -- ROT point 6 de courbe

	if modif == rot then -- si selectionné
	valeur =  point[6] -- POINT 6
	
	if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
			valeur = choose(valeur,-100,0,1) -- detection rotary next ou prev
	end
	if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
	 	valeur = choose(valeur,-100,0,-1) -- detection rotary next ou prev
	end
		
	point[6] = valeur  -- POINT 6
	tab.y = point
	model.setCurve(0,tab)  -- COURBE br 0
		
	cadre(66+pos[6]/2,13-point[6]/2,1,point[6],2,3) -- dessin POINT 6   -   PT 2/3
	
	else -- si pas selectionné
	cadre(66+pos[6]/2,13-point[6]/2,0,point[6],2,3)   -- dessin POINT 6   -   PT 2/3
	end
end

if rot == 28 then -- ROT point 7 de courbe

	if modif == rot then -- si selectionné
	valeur =  point[7] -- POINT 7
	
	if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
			valeur = choose(valeur,-100,0,1) -- detection rotary next ou prev
	end
	if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
	 	valeur = choose(valeur,-100,0,-1) -- detection rotary next ou prev
	end
		
	point[7] = valeur  -- POINT 7
	tab.y = point
	model.setCurve(0,tab)  -- COURBE br 0
		
	cadre(66+pos[7]/2,13-point[7]/2,1,point[7],3,3) -- dessin POINT 7   -   PT 3/3
	
	else -- si pas selectionné
	cadre(66+pos[7]/2,13-point[7]/2,0,point[7],3,3)   -- dessin POINT 7   -   PT 3/3
	end
end

-- Tracer courbe :
lcd.drawLine(66+pos[3]/2,13+50,66+pos[4]/2,13+50, SOLID, FORCE)
lcd.drawLine(66+pos[4]/2,13+50,66+pos[5]/2,13-point[5]/2, SOLID, FORCE)
lcd.drawLine(66+pos[5]/2,13-point[5]/2,66+pos[6]/2,13-point[6]/2, SOLID, FORCE)
lcd.drawLine(66+pos[6]/2,13-point[6]/2,66+pos[7]/2,13-point[7]/2, SOLID, FORCE)
lcd.drawLine(66+pos[7]/2,13-point[7]/2,66,13, SOLID, FORCE)
  
	-- Tracer valeur live br :
if getValue('input31') <0 then   -- valeur  input15 (frein premiere partie) sur 100 

		if getValue('input31')/10.24 < pos[4] then -- si valeur frein avant le point a 100% 
		lcd.drawLine(66+1,13+50,66+2,13+50, SOLID, FORCE)    
		lcd.drawText(70, 58, "-100", SMLSIZE) 
		else
		lcd.drawLine(66+1,13-(getValue('input15')/10.24 )/2,66+2,13-(getValue('input15')/10.24 )/2, SOLID, FORCE)    
		lcd.drawText(70, 58, math.floor(getValue('input15')/10.24), SMLSIZE) 
		end

	lcd.drawLine(66+(getValue('input31')/10.24 )/2,13-1,66+(getValue('input31')/10.24 )/2,13-2, SOLID, FORCE)    
	lcd.drawText(0, 11, math.floor(getValue('input31')/10.24), SMLSIZE) 
	else
		lcd.drawText(0, 11, "0", SMLSIZE) 
		
	lcd.drawText(70, 58, "0", SMLSIZE) 
end   
   
--  ========================   FIN  PAGE 5    ======================  
   
elseif (rot >28 and rot<31) then -- rot= 24  ========================    PAGE 6    ======================  
   
   -- AXEs de  Courbe St
lcd.drawText(85, 11, "Courbe St" , SMLSIZE+INVERS) -- gaz
lcd.drawLine(15,61,66,61, SOLID, FORCE)
lcd.drawLine(17,12,17,60, SOLID, FORCE)
lcd.drawLine(17,62,17,63, SOLID, FORCE)
-- Point Zero a 17,61



local tab = model.getCurve(5) -- COURBE cor 6
local point = {}
local pos = {}
point = tab.y  -- point[1]  c'est la valeur y du premier point de la courbe
pos = tab.x


if rot == 29 then -- ROT point 2 et 5 de courbe

	if modif == rot then -- si selectionné
	valeur =  point[2] -- POINT 2
	ecar = point[2]-point[3]
	if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
		valeur = choose(valeur,70,100,5) -- detection rotary next ou prev
	end
	if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
	 valeur = choose(valeur,70,100,-5) -- detection rotary next ou prev
	end
		
	point[2] = valeur  -- POINT 2
	point[5] = valeur  -- POINT 5
	point[3] = valeur - ecar  -- POINT 3
	point[4] = valeur - ecar   -- POINT 4
	tab.y = point
	model.setCurve(5,tab)  -- COURBE cor 6
		
			
	end
	
lcd.drawText(85, 29, point[2] .. " %" , SMLSIZE+INVERS) -- texte	
else -- si pas selection
	lcd.drawText(85, 29, point[2] .. " %" , SMLSIZE) -- texte
	
end



if rot == 30 then -- ROT point 3 et 4 de courbe

	if modif == rot then -- si selectionné
	valeur =  point[2]-point[3] -- POINT 3
	
	if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
		valeur = choose(valeur,0,30,5) -- detection rotary next ou prev
	end
	if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
	 valeur = choose(valeur,0,30,-5) -- detection rotary next ou prev
	end
		
	
	point[3] = point[2] - valeur  -- POINT 3
	point[4] = point[2] - valeur   -- POINT 4
	tab.y = point
	model.setCurve(5,tab)  -- COURBE cor 6
		
			
	end
	
	lcd.drawText(85, 47, point[2]-point[3] .. " %" , SMLSIZE+INVERS) -- texte
else -- si pas selection
	lcd.drawText(85, 47, point[2]-point[3] .. " %" , SMLSIZE) -- texte
	
end



-- valeur linearité courbe
lcd.drawText(75, 21, "Linearity", SMLSIZE) 
lcd.drawText(75, 39, "Prec. Neutre", SMLSIZE) 


lcd.drawText(86, 57, "& Exp:", SMLSIZE) 
lcd.drawText(112, 57,  math.floor(G4/7), SMLSIZE) 

	-- Tracer courbe :
	

	for i= 0, 70, 10 do
		if i < 20 then
		lcd.drawLine(17+i/2,     61-((G4/100*math.pow(i/100,3) + (1-G4/100)*i/100)*point[2]/2)*point[3]/point[2],      17+(i+10)/2,      61-((G4/100*math.pow(i/100+0.1,3) + (1-G4/100)*(i+10)/100)*point[2]/2)*point[3]/point[2], SOLID, FORCE)
		else
		lcd.drawLine(17+i/2,     61-((G4/100*math.pow(i/100,3) + (1-G4/100)*i/100)*point[2]/2)*(point[3]+(i/10-2)*(point[2]-point[3])/6)/point[2],      17+(i+10)/2,      61-((G4/100*math.pow(i/100+0.1,3) + (1-G4/100)*(i+10)/100)*point[2]/2)*(point[3]+(i/10-2)*(point[2]-point[3])/6)/point[2], SOLID, FORCE)
		end
	
	end
	
lcd.drawLine( 17+40,      61-(G4/100*math.pow(0.8,3) + (1-G4/100)*0.8)*point[2]/2,     17+45,      61-(G4/100*math.pow(0.9,3) + (1-G4/100)*0.9)*((100-point[2])/2+point[2])/2   , SOLID, FORCE)	

lcd.drawLine( 17+45,    61-(G4/100*math.pow(0.9,3) + (1-G4/100)*0.9)*((100-point[2])/2+point[2])/2  ,     17+50,   61-50  , SOLID, FORCE)


	-- Tracer valeur live st :
if getValue('input30') >0 then   -- valeur  input 30 (st) sur 100
	lcd.drawLine(17+(getValue('input30')/10.24 )/2,61+1,17+(getValue('input30')/10.24 )/2,61+2, SOLID, FORCE)    
	lcd.drawText(70, 58, math.floor(getValue('input30')/10.24), SMLSIZE) 
	else
	lcd.drawText(70, 58, "0", SMLSIZE) 
end

if getValue('ch14') >0 then   -- valeur  ch14 (st avec expo et courbe cor) sur 100
	lcd.drawLine(17-2,61-(getValue('ch14')/10.24)/2,17-1,61-(getValue('ch14')/10.24)/2, SOLID, FORCE)    
	lcd.drawText(0, 11, math.floor(getValue('ch14')/10.24), SMLSIZE) 
	else
		lcd.drawText(0, 11, "0", SMLSIZE) 
   
end
   --  ========================   FIN  PAGE 6    ======================  
end   -- ==========FIN PAGES ------------
	  
  
  -- page:
lcd.drawNumber(123, 56,"5", 0+INVERS) -- texte numero page

end