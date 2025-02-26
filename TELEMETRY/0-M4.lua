local shared = ...

local valeur = 0 -- valeur en cour de modif

local fich2 = "/SCRIPTS/TELEMETRY/" .. string.sub(model.getInfo().name,1,1) .. "-timr.txt"
local sess -- dernier preset ouvert
local modif = 0 --   =0 si pas mode modif et =valeur de rot si modif de cet item 
local rebound = 0 -- anti rebond Enter key
local rot = 1 -- numero item a modifier (commande par rotary)
local text =  {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", " " } -- derniere index= 37
local mem = {37,37,37,37,37,37,37,37,37,37,0,0,0,0,0,0,0,0,0} -- stockage mem  circuit + sauvegarde valeur
local debut = 0

  
 local function case(x,y,coche) -- coche : 0= rien 1=cocher 2=rien noir 3=coche noir

lcd.drawRectangle(x, y, 8, 8, SOLID)

if coche == 1 then
lcd.drawLine(x+1,y+1,x+6,y+6, SOLID, FORCE)
lcd.drawLine(x+1,y+6,x+6,y+1, SOLID, FORCE)
elseif coche == 2 then
lcd.drawLine(x+1,y+1,x+6,y+1, SOLID, FORCE)
lcd.drawLine(x+1,y+2,x+6,y+2, SOLID, FORCE)
lcd.drawLine(x+1,y+3,x+6,y+3, SOLID, FORCE)
lcd.drawLine(x+1,y+4,x+6,y+4, SOLID, FORCE)
lcd.drawLine(x+1,y+5,x+6,y+5, SOLID, FORCE)
lcd.drawLine(x+1,y+6,x+6,y+6, SOLID, FORCE)
elseif coche == 3 then
lcd.drawLine(x+1,y+1,x+6,y+1, SOLID, FORCE)
lcd.drawLine(x+1,y+2,x+6,y+2, SOLID, FORCE)
lcd.drawLine(x+1,y+3,x+6,y+3, SOLID, FORCE)
lcd.drawLine(x+1,y+4,x+6,y+4, SOLID, FORCE)
lcd.drawLine(x+1,y+5,x+6,y+5, SOLID, FORCE)
lcd.drawLine(x+1,y+6,x+6,y+6, SOLID, FORCE)
lcd.drawLine(x+1,y+1,x+6,y+6, SOLID, ERASE)
lcd.drawLine(x+1,y+6,x+6,y+1, SOLID, ERASE)
end
end
  
  
local function rond(x,y,coche) -- coche : 0= rien 1=cocher 

lcd.drawLine(2+x,0+y,3+x,0+y, SOLID, FORCE)
lcd.drawPoint(1+x,1+y)
lcd.drawPoint(4+x,1+y)
lcd.drawPoint(1+x,4+y)
lcd.drawPoint(4+x,4+y)
lcd.drawLine(2+x,5+y,3+x,5+y, SOLID, FORCE)
lcd.drawLine(0+x,2+y,0+x,3+y, SOLID, FORCE)
lcd.drawLine(5+x,2+y,5+x,3+y, SOLID, FORCE)

if coche == 1 then
lcd.drawFilledRectangle(x+1, y+1, 4, 4, SOLID)
end

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
  
  
local function data(x) -- sauvegarde mise en forme 2 carac

		x = tostring(x)  -- convertir en string  
		
		if (#x==1) then -- nombre a 1 chiffre
			x = "x" .. x  -- completer pour 2 carac 
			
			elseif (#x>2) then -- si = 2 ou plus
			x = "11"   -- completer pour 2 carac
			
		end
		
		return x
end

local function lire(x) -- lire de carte sd
x = tostring(x)  -- convertir en strings
x = string.gsub(x,"x","")  -- enlever les xx 
if (x=="") then -- variable non assigné
	x = "1"  -- mettre variable a a
end
x = tonumber(x) -- convertir en nombre

return x
end  
  
  
  
local function sdmem(x,y) -- sd vers mem puis ver LS     -- x= fich2     y= sess

	local file = io.open(x, "r") -- ouvrir fichier 0-timr.txt en acces lecture
		
	---- lire sd et copie dans mem[..] ------
		for i = 1,17 do 
			local curs = io.seek(file, 10+2*i+50*(y-1) ) --  positionner curseur dans fichier  
			mem[i] = io.read (file, 2) -- lire 2 carac   dans fichier  et asssigner
			mem[i] = lire(mem[i]) -- convertir lecture
		end
			
	io.close(file) -- fermer fichier
	
	
	---- copie mem[..] vers LS ------
		local tab = model.getLogicalSwitch(10)
		tab.v2 = mem[11] 
		tab.delay = mem[12]
		tab.duration = mem[13]
			model.setLogicalSwitch(10, tab) -- assigner valeur de LS
		tab = model.getLogicalSwitch(11)
		if mem[14] == 1 then -- positif droite
		tab.v2 = mem[15]
		tab.func = LS_FUNC_VPOS
		else -- neg gauche
		tab.v2 = -mem[15]
		tab.func = LS_FUNC_VNEG
		end
		tab.delay = mem[16]
			model.setLogicalSwitch(11, tab) -- assigner valeur de LS
		tab = model.getLogicalSwitch(12)
		tab.v2 = mem[17]
		shared.ls13 = mem[17] -- reassigner valeur lap mini
			model.setLogicalSwitch(12, tab) -- assigner valeur de LS

		


end  
  
  
  
  
  
  
  
function shared.run(event)
  lcd.clear()



if debut == 0 then
	local file = io.open(fich2, "r") -- ouvrir fichier 0-timr.txt en acces lecture
	
	---- lire sd et copie dans sess ------
	local curs = io.seek(file, 1 ) --  positionner curseur dans fichier  
			sess = io.read (file, 2) -- lire 2 carac   dans fichier  et asssigner
	sess = lire(sess) -- conversion
			
	io.close(file) -- fermer fichier
	
	sdmem(fich2,sess) -- lire sd et copie vers mem et LS
			
	
	
debut = 1
end


---- touche bascule entre ecran -----------------
 if event == EVT_VIRTUAL_MENU then -- bouton menu 
 playTone(1200, 120,5) -- play tone
    shared.changeScreen(7)
  end
  
 if event == EVT_VIRTUAL_MENU_LONG then -- bouton menu 
 playTone(1200, 120,5) -- play tone
    shared.changeScreen(1)
  end
    
lcd.drawText(1, 1, "LAP TIMER                                " , 0+INVERS) -- TITRE
  

  

--- code -----
if (modif == 0) then -- si mode choix item ====================
	if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
    rot = rot+1 -- allez item suivant
	playTone(1200, 50,5) -- play tone
		if (rot >19) then -- max item
		rot =1
		end
	end
	if event == EVT_VIRTUAL_PREV then -- bouton rotary  prev
    rot = rot-1
	playTone(1200, 50,5) -- play tone
		if (rot <1) then
		rot =19     --   max item
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
	
	---- sauver num preset sur sd ----
	 local file = io.open(fich2, "a") -- ouvrir fichier 0-mem.txt en acces ecriture et en preservant son contenu
		    			
			 local curs = io.seek(file, 1) --  positionner curseur dans fichier 
			 local ecri = io.write (file, data(sess)) --  ecri 2 carac  dans fichier 
	
	---- sauver mem[..]  sur sd ----
	for i = 1,17 do
			 local curs = io.seek(file, 10+2*i+50*(sess-1)) --  positionner curseur dans fichier 
			 local ecri = io.write (file, data(mem[i])) --  ecri 2 carac  dans fichier 
			end
		
	 io.close(file) -- fermer fichier   
	
	
	rebound = getTime()

	modif = 0 -- revenir a mode choix item
	end	
end


if (rot <19) then --========================    PAGE 1    ======================

  --========================= affiche texte fond =================================


if getValue('ls13') > 0 then -- affiche rond si detection ok
	rond(0,11,1) -- affiche rond
	else
	rond(0,11,0) -- affiche rond vide
end

lcd.drawText(9, 11, "Trigger" , SMLSIZE+INVERS) -- texte fond noir
lcd.drawText(60, 11, "Lap Auto" , SMLSIZE) -- texte  

lcd.drawText(1, 20, "Preset:" , SMLSIZE+INVERS) -- texte fond noir
lcd.drawText(54, 20, "-" , SMLSIZE) -- texte
lcd.drawLine(0,27,127,27, SOLID, FORCE)

if getValue('ls11') > 0 then -- affiche rond si detection ok
	rond(4,30,1) -- affiche rond
	else
	rond(4,30,0) -- affiche rond vide
end

lcd.drawText(13, 30, "Th:" , SMLSIZE+INVERS) -- texte fond noir  
lcd.drawText(28, 30, ">" , SMLSIZE) -- texte    
lcd.drawText(74, 30, "durant" , SMLSIZE) -- texte   
lcd.drawText(5, 39, "Puis dans delai de:" , SMLSIZE) -- texte  


if getValue('ls12') > 0 then -- affiche rond si detection ok
	rond(4,48,1) -- affiche rond
	else
	rond(4,48,0) -- affiche rond vide
end

lcd.drawText(13, 48, "St:" , SMLSIZE+INVERS) -- texte fond noir  
lcd.drawText(28, 48, ">" , SMLSIZE) -- texte    
lcd.drawText(74, 48, "durant" , SMLSIZE) -- texte   

lcd.drawText(5, 57, "Lap mini:" , SMLSIZE+INVERS) -- texte fond noir
 

   
 -- ========================== affiche valeur ========================================

if rot==1 then -------------- VALEUR activation mode lap auto   /   Logic Switch L13  
  
  ------ affiche valeur selectionnne -----
if model.getLogicalSwitch(12).func == LS_FUNC_VPOS then -- si logical switch a>x  (lap auto activé)
	case(100,10,3)
	else
	case(100,10,2)
end

	if modif == rot then -- si mode modif sur cet item

	local tab = model.getLogicalSwitch(12)
	
	if  tab.func ==  LS_FUNC_VPOS then -- si ls12   a>x (lap auto activé)
	valeur = 1
	else
	valeur = 0
	end
	
	if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
		valeur = choose(valeur,0,1,1) -- detection rotary next ou prev
	end
	if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
	 valeur = choose(valeur,0,1,-1) -- detection rotary next ou prev
	end
	
	if  valeur ==  1 then -- si ls12   (lap auto activé)
	tab.func = LS_FUNC_VPOS
	model.setLogicalSwitch(12, tab) -- assigner valeur de LS
	else
	tab.func = LS_FUNC_VEQUAL
	model.setLogicalSwitch(12, tab) -- assigner valeur de LS
	end
	
	

	end

else ------ affiche valeur non selectionne -----

if model.getLogicalSwitch(12).func == LS_FUNC_VPOS then -- si logical switch a>x  (lap auto activé)
	case(100,10,1)
	else
	case(100,10,0)
end

end -- fin rot





if rot==2 then -------------- Choix preset reglage 
	------ affiche valeur selectionnne -----
	lcd.drawText(40, 20, sess , SMLSIZE+INVERS) -- texte fond noir

		if modif == rot then -- si mode modif sur cet item

		
		valeur = sess -- lire valeur session en cours
		
		if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
			valeur = choose(valeur,1,15,1) -- detection rotary next ou prev
			sess = valeur -- assigne nouvelle valeur
			sdmem(fich2,sess) -- lire sd et copie vers mem et LS
		end
		if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
		 valeur = choose(valeur,1,15,-1) -- detection rotary next ou prev
		 sess = valeur -- assigne nouvelle valeur
		 sdmem(fich2,sess) -- lire sd et copie vers mem et LS
		end
		
		
		
		end


	else ------ affiche valeur non selectionne -----
	lcd.drawText(40, 20, sess , SMLSIZE) -- texte 

end -- fin rot


for i = 3,12 do -- balaye tous les carac

		if rot==i then -------------- Choix preset reglage 
			------ affiche valeur selectionnne -----
			lcd.drawText(63+6*(i-3), 20, text[mem[i-2]] , SMLSIZE+INVERS) -- texte fond noir

				if modif == rot then -- si mode modif sur cet item

				
				valeur = mem[i-2] -- lire valeur session en cours
				
				if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
					valeur = choose(valeur,1,37,1) -- detection rotary next ou prev
					
				end
				if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
				 valeur = choose(valeur,1,37,-1) -- detection rotary next ou prev
				 
				end
				
				mem[i-2] = valeur
				
				end


			else ------ affiche valeur non selectionne -----
			lcd.drawText(63+6*(i-3), 20, text[mem[i-2]] , SMLSIZE) -- texte  

		end -- fin rot
		
end



if rot==13 then -------------- VALEUR pourcentage th - lap auto  /   Logic Switch L11  

------ affiche valeur selectionnne -----
lcd.drawText(37, 30, model.getLogicalSwitch(10).v2 .. " %" , SMLSIZE+INVERS) -- texte fond noir

	if modif == rot then -- si mode modif sur cet item

	local tab = model.getLogicalSwitch(10)
	valeur = tab.v2 -- lire valeur de LS
	
	if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
		valeur = choose(valeur,1,99,1) -- detection rotary next ou prev
	end
	if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
	 valeur = choose(valeur,1,99,-1) -- detection rotary next ou prev
	end
	
	tab.v2 = valeur
	model.setLogicalSwitch(10, tab) -- assigner valeur de LS
	mem[11] = valeur -- copier dans mem
	end

else ------ affiche valeur non selectionne -----
lcd.drawText(37, 30, model.getLogicalSwitch(10).v2 .. " %" , SMLSIZE) -- texte

 end -- fin rot
   
   
if rot==14 then -------------- VALEUR delai th - lap auto  /   Logic Switch L11  

------ affiche valeur selectionnne -----
lcd.drawText(108, 30, model.getLogicalSwitch(10).delay/10 .. " s" , SMLSIZE+INVERS) -- texte fond noir

	if modif == rot then -- si mode modif sur cet item

	local tab = model.getLogicalSwitch(10)
	valeur = tab.delay -- lire valeur de LS
	
	if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
		valeur = choose(valeur,1,99,1) -- detection rotary next ou prev
	end
	if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
	 valeur = choose(valeur,1,99,-1) -- detection rotary next ou prev
	end
	
	tab.delay = valeur
	model.setLogicalSwitch(10, tab) -- assigner valeur de LS
	mem[12] = valeur -- copier dans mem
	end

else ------ affiche valeur non selectionne -----
lcd.drawText(108, 30, model.getLogicalSwitch(10).delay/10 .. " s" , SMLSIZE) -- texte

 end -- fin rot
 
 
if rot==15 then -------------- VALEUR duration th - lap auto  /   Logic Switch L11  

------ affiche valeur selectionnne -----
lcd.drawText(93, 39, model.getLogicalSwitch(10).duration/10 .. " s" , SMLSIZE+INVERS) -- texte fond noir

	if modif == rot then -- si mode modif sur cet item

	local tab = model.getLogicalSwitch(10)
	valeur = tab.duration -- lire valeur de LS
	
	if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
		valeur = choose(valeur,1,99,1) -- detection rotary next ou prev
	end
	if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
	 valeur = choose(valeur,1,99,-1) -- detection rotary next ou prev
	end
	
	tab.duration = valeur
	model.setLogicalSwitch(10, tab) -- assigner valeur de LS
	mem[13] = valeur -- copier dans mem
	end

else ------ affiche valeur non selectionne -----
lcd.drawText(93, 39, model.getLogicalSwitch(10).duration/10 .. " s" , SMLSIZE) -- texte

 end -- fin rot
   
   
   
 if rot==16 then -------------- VALEUR pourcentage St  - lap auto  /   Logic Switch L12  

------ affiche valeur selectionnne -----

if model.getLogicalSwitch(11).v2 >= 0  then -- si positif ca veut dire que c'est a droite
	lcd.drawText(37, 48, "D " .. math.abs(model.getLogicalSwitch(11).v2) .. " %" , SMLSIZE+INVERS) -- texte fond noir
	else
	lcd.drawText(37, 48, "G " .. math.abs(model.getLogicalSwitch(11).v2) .. " %" , SMLSIZE+INVERS) -- texte fond noir
end

	if modif == rot then -- si mode modif sur cet item

	local tab = model.getLogicalSwitch(11)
	valeur = tab.v2 -- lire valeur de LS
	
	if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
		valeur = choose(valeur,-99,99,1) -- detection rotary next ou prev
	end
	if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
	 valeur = choose(valeur,-99,99,-1) -- detection rotary next ou prev
	end
	
	tab.v2 = valeur
	if valeur >= 0 then -- si positive on doit detecter a>x sinon a<x
		tab.func = LS_FUNC_VPOS
		else
		tab.func = LS_FUNC_VNEG
	end
	model.setLogicalSwitch(11, tab) -- assigner valeur de LS
	
		if valeur >=0 then  -- copier dans mem
		mem[14] = 1 -- positif Droite
		else
		mem[14] = 0 -- negatig gauche
		end
		mem[15] = math.abs(valeur) -- copier dans mem
		
	end

else ------ affiche valeur non selectionne -----

if model.getLogicalSwitch(11).v2 >= 0  then -- si positif ca veut dire que c'est a droite
	lcd.drawText(37, 48, "D " .. math.abs(model.getLogicalSwitch(11).v2) .. " %" , SMLSIZE) -- texte  
	else
	lcd.drawText(37, 48, "G " .. math.abs(model.getLogicalSwitch(11).v2) .. " %" , SMLSIZE) -- texte  
end

 end -- fin rot
 
 
 
 
 
if rot==17 then -------------- VALEUR delai St - lap auto  /   Logic Switch L12  

------ affiche valeur selectionnne -----
lcd.drawText(108, 48, model.getLogicalSwitch(11).delay/10 .. " s" , SMLSIZE+INVERS) -- texte fond noir

	if modif == rot then -- si mode modif sur cet item

	local tab = model.getLogicalSwitch(11)
	valeur = tab.delay -- lire valeur de LS
	
	if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
		valeur = choose(valeur,1,99,1) -- detection rotary next ou prev
	end
	if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
	 valeur = choose(valeur,1,99,-1) -- detection rotary next ou prev
	end
	
	tab.delay = valeur
	model.setLogicalSwitch(11, tab) -- assigner valeur de LS
	mem[16] = valeur -- copier dans mem
	
	end

else ------ affiche valeur non selectionne -----
lcd.drawText(108, 48, model.getLogicalSwitch(11).delay/10 .. " s" , SMLSIZE) -- texte

 end -- fin rot
 
 
if rot==18 then -------------- VALEUR lap mini   - lap auto  /   Logic Switch L13  

------ affiche valeur selectionnne -----
lcd.drawText(49, 57, model.getLogicalSwitch(12).v2 .. " s" , SMLSIZE+INVERS) -- texte fond noir

	if modif == rot then -- si mode modif sur cet item

	local tab = model.getLogicalSwitch(12)
	valeur = tab.v2 -- lire valeur de LS
	
	if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
		valeur = choose(valeur,1,90,1) -- detection rotary next ou prev
	end
	if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
	 valeur = choose(valeur,1,90,-1) -- detection rotary next ou prev
	end
	
	tab.v2 = valeur
	model.setLogicalSwitch(12, tab) -- assigner valeur de LS
	mem[17] = valeur -- copier dans mem
	
	shared.ls13 = valeur -- reassigner valeur lap mini
	end

else ------ affiche valeur non selectionne -----
	lcd.drawText(49, 57, model.getLogicalSwitch(12).v2 .. " s" , SMLSIZE) -- texte

end -- fin rot
 
 
 

 
   
elseif (rot >18 and rot<20) then --========================    PAGE 2    ======================  
    
  
   --========================= affiche texte fond =================================

 lcd.drawText(1, 11, "Bip alerte best lap" , SMLSIZE+INVERS) -- texte fond noir
  
  
  
  
  
  
  
  if rot==19 then -------------- VALEUR bip tps best lap   /   Logic Switch L13  

------ affiche valeur selectionnne -----

if model.getLogicalSwitch(12).duration == 5 then -- si annonce bip tps mini activé
	case(91,10,3)
	else
	case(91,10,2)
end


	if modif == rot then -- si mode modif sur cet item

	local tab = model.getLogicalSwitch(12)
	valeur = tab.duration -- lire valeur de LS
	
	if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
		valeur = choose(valeur,5,6,1) -- detection rotary next ou prev
	end
	if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
	 valeur = choose(valeur,5,6,-1) -- detection rotary next ou prev
	end
	
	tab.duration = valeur
	model.setLogicalSwitch(12, tab) -- assigner valeur de LS
	shared.bip = model.getLogicalSwitch(12).duration
	end

else ------ affiche valeur non selectionne -----

	if model.getLogicalSwitch(12).duration == 5 then -- si annonce bip tps mini activé
	case(91,10,1)
	else
	case(91,10,0)
end

end -- fin rot
   


end   -- ==========FIN PAGES ------------
	  
  
  -- page:
lcd.drawNumber(123, 56,"4", 0+INVERS) -- texte numero page

end