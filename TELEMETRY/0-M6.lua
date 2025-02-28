local shared = ...


local z = 0  
local filestemp = {}
local nbfile = 0 -- nb de fichier log dans dossier LOGS
local item = string.sub(model.getInfo().name,1,1) -- recup numero model


for fname in dir("/LOGS") do -- lister fichier dans LOGS
    
		if string.sub(fname,1,1) == item then -- trie seulement fichier log correspondant au model en cours
		z = z+1
		filestemp[z] = fname
		
		end
end


-- Fonction de tri par insertion (ordre alphabétique décroissant)
for i = 2, #filestemp do
    local current = filestemp[i]
    local j = i - 1
    while j >= 1 and filestemp[j] < current do  -- On compare dans l'ordre décroissant
        filestemp[j + 1] = filestemp[j]
        j = j - 1
    end
    filestemp[j + 1] = current
end


-- Garder seulement les 30 premiers fichiers (les plus proches de la fin de l'alphabet)
local files = {}
local nbfile = math.min(30, #filestemp)
for i = 1, nbfile do
    files[i] = filestemp[i]  -- On insère directement dans le tableau avec un indice
end

local filestemp = {} -- vider filestemp





z = 1 -- Compteur pour indexer la table des valeurs de la 3e colonne
local fich = 1 -- index fichier log a lire

local rot = 1  -- numero item a modifier (commande par rotary)
local modif = 0  --   =0 si pas mode modif et =valeur de rot si modif de cet item 
local rebound = 0 -- anti rebond Enter key
local valeur = 0 -- valeur en cour de modif

local debut = 0 -- init

local curs = 0 -- position curseur tps sur graph (par pas de 0.5 s )  (de 0 a 119)
local interval = 0 -- numero de la minute a visualiser 0= de 0 a 0:59 min

local numitem = 3 -- numero de l'item log a visualiser
item = "_" -- nom de l'item log a visualiser
local item_val = {}  -- Table pour stocker les valeurs de la colonne de l'item log a visualiser
local duree = 0  -- duree en minute du log


local mult = {} -- multiplicateur pour affichage valeur item      en fonction de numitem ,   mult[reper]
local unit = {} --  pour affichage unité item   
local curvmult = {} -- multiplicateur pour affichage courbe item   on a une plage en y de 45 pixel pour afficher courbe   
local curvdec = {} -- decalage pour affichage courbe item  
local ori = {} -- origine courbe 
local orival = {} -- val a afficher origine courbe
local reper = 1 -- decalage indexation table     assigner reper en fonction de numitem

--_1_____2_____3_______4_________5_______6________7_______8________9_______10______11___12__13_...._16_17...21___22_....._53_______54     numitem
--Date,Time,1RSS(dB),2RSS(dB),TPWR(mW),Lipo___,Curr(mA),Temp(°C),Rpm(kmh),Capa___,ST__,TH__,P1......P4,SA......LSW,CH1(us),CH32(us),TxBat(V)
--_____________1_______2_________3_______4________5_______6________7_______8________9....9___10.....10_11.......11_12.......12_______13       reper
unit =     {"db"    , "db"   ,  "mW"  , "V"   , "A"   ,  "°C"   , "kmh"  , "mAh" ,  " "    ,  "%"      ,   " "   ,  "us"          ,  "V"   }
mult=      {    1   ,    1   ,    1   ,0.001  , 0.001 ,     1   ,   1    ,   1   ,    1    ,    1      ,    1    ,     1          ,   1    }
curvmult = { 0.375  , 0.375  ,  0.45  ,0.03   ,0.00045,   0.45  ,   1    , 0.006 ,  0.021  ,  0.04     ,    20   ,     0.03       ,   18   }
curvdec =  {  120   , 120    ,    0   , -3000 ,   0   ,     0   ,   0    ,   0   ,   1024  ,  0        ,    1    ,     -750       ,   -6   }
ori=       {    0   ,    0   ,    0   , 4000  ,   0   ,     0   ,   0    ,   0   ,    0    ,    0      ,    0    ,     1500       ,   7    }
orival=    {   "M"  ,   "M"  ,   "0"  ,  "4"  ,  "0"  ,    "0"  ,  "0"   ,  "0"  ,   "c"   ,   "0"     ,   "0"   ,    "c"         ,  "7"   }
 
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


--- code rotary -----
if (modif == 0) then -- si mode choix item ====================
	if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
    rot = rot+1 -- allez item suivant
	
		if (rot >4) then -- max item
		rot =4
		else
		playTone(1200, 50,5) -- play tone
		end
	end
	if event == EVT_VIRTUAL_PREV then -- bouton rotary  prev
    rot = rot-1
	
		if (rot <1) then
		rot =1     --   max item
		else
		playTone(1200, 50,5) -- play tone
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
	
	if modif == 1 then -- si entré sur nom de fichier on lit le fichier
	debut = 0
	end
	
	modif = 0 -- revenir a mode choix item
	
	
	
	
	end	
end





if duree == 0 then  -- compter nb ligne et donc duree du fichier log

-- reset les curseur et item
 curs = 0  
 interval = 0 


local file = io.open("/LOGS/" .. files[fich], "r")
	

		
	if file then
	   
		local buffer = ""  -- Buffer pour accumuler les caractères lus
	
		-- Position initiale du fichier
		local file_pos = 0

		local current_line = 1 -- ligne en cours

		-- Lire le fichier en morceaux et gérer les sauts de ligne
		while true do
			-- Lire 100 caractères à partir de la position courante avec io.read(file, 100)
			io.seek(file, file_pos)  -- Déplacer le curseur à la position actuelle
			local temp = io.read(file, 100)
			
			if not temp or #temp == 0 then
				break  -- Si fin de fichier ou rien à lire, sortir de la boucle
			end

			-- Ajouter le morceau au buffer
			buffer = buffer .. temp

			-- Mettre à jour la position du fichier
			file_pos = file_pos + #temp

			-- Chercher si un saut de ligne est présent
			while true do
				local line_end = string.find(buffer, "\n")  -- Cherche le premier saut de ligne

				if not line_end then
					break  -- Pas de saut de ligne trouvé, continuer à lire plus de données
				end

				-- Extraire la ligne avant le saut de ligne
				local line = string.sub(buffer, 1, line_end - 1)
				buffer = string.sub(buffer, line_end + 1)  -- Mettre à jour le buffer en enlevant la ligne lue

				
				-- Incrémenter le compteur de lignes
				duree =  current_line -- compter nombre de ligne et deduire duree log
				current_line = current_line + 1
						
				
			end
		end

		-- Fermer le fichier
		io.close(file) -- fermer fichier log


	end


end









if debut == 0 then -- faire que au demarrage ecran
	
local file = io.open("/LOGS/" .. files[fich], "r")
	

		
	if file then
	   
		local buffer = ""  -- Buffer pour accumuler les caractères lus
		 z = 1  -- Compteur pour indexer la table des valeurs de la 3e colonne

		-- Position initiale du fichier
		local file_pos = 0

		local current_line = 1 -- ligne en cours

		-- Lire le fichier en morceaux et gérer les sauts de ligne
		while true do
			-- Lire 100 caractères à partir de la position courante avec io.read(file, 100)
			io.seek(file, file_pos)  -- Déplacer le curseur à la position actuelle
			local temp = io.read(file, 100)
			
			if not temp or #temp == 0 then
				break  -- Si fin de fichier ou rien à lire, sortir de la boucle
			end

			-- Ajouter le morceau au buffer
			buffer = buffer .. temp

			-- Mettre à jour la position du fichier
			file_pos = file_pos + #temp

			-- Chercher si un saut de ligne est présent
			while true do
				local line_end = string.find(buffer, "\n")  -- Cherche le premier saut de ligne

				if not line_end then
					break  -- Pas de saut de ligne trouvé, continuer à lire plus de données
				end

				-- Extraire la ligne avant le saut de ligne
				local line = string.sub(buffer, 1, line_end - 1)
				buffer = string.sub(buffer, line_end + 1)  -- Mettre à jour le buffer en enlevant la ligne lue


				if current_line == 1 then -- recup titre ligne 1
					-- Séparer la ligne en utilisant la virgule
					local i = 1  -- Compteur pour les colonnes
					for value in string.gmatch(line, '([^,]+)') do
										
							if i == numitem then   -- Ajouter la valeur de la 3e colonne à la table
								-- Assigner directement la valeur à l'indice z
								item = value							
								break  -- Pas besoin de continuer à lire les autres colonnes
							end
						
						i = i + 1
					end
				end


				if current_line >= 2+interval*120 and current_line <= 2+interval*120 +120 then -- ne prendre que entre ligne 1 et 120
					-- Séparer la ligne en utilisant la virgule
					local i = 1  -- Compteur pour les colonnes
					for value in string.gmatch(line, '([^,]+)') do
										
							if i == numitem then   -- Ajouter la valeur de la 3e colonne à la table
								-- Assigner directement la valeur à l'indice z
								item_val[z] = value
								z = z + 1  -- Incrémenter z pour la prochaine ligne
								break  -- Pas besoin de continuer à lire les autres colonnes
							end
						
						i = i + 1
					end
				end
				
				-- Incrémenter le compteur de lignes
				current_line = current_line + 1
				
				
				
			end
			
			if current_line > 2+interval*120 +120 then -- si apres les lignes souhaitée on quitte boucle
			break
			end
			
		end

		-- Fermer le fichier
		io.close(file) -- fermer fichier log


	end
	
debut = 1
end


---- touche bascule entre ecran -----------------
 if event == EVT_VIRTUAL_MENU then -- bouton menu 
 playTone(1200, 120,5) -- play tone
    shared.changeScreen(9)
  end
  
 if event == EVT_VIRTUAL_MENU_LONG then -- bouton menu 
 playTone(1200, 120,5) -- play tone
    shared.changeScreen(1)
  end
    
lcd.drawText(1, 1, "LOG" , 0+INVERS) -- TITRE
  

  

------ code affichage -----








-- valeurs

lcd.drawText(37, 1, string.sub(files[fich],15,16) .. "/" .. string.sub(files[fich],12,13)  .. " " .. string.sub(files[fich],18,19) .. ":" .. string.sub(files[fich],20,21) , SMLSIZE) --   n° session (date et heure)



if rot==1 then -------------- modif item a afficher
------ affiche valeur selectionnne -----
lcd.drawText(20, 1, fich , 0+INVERS) --   n° session 

	if modif == rot then -- si mode modif sur cet item
	valeur = fich -- lire valeur
		
		if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
			valeur = choose(valeur,1,nbfile,1) -- 1 a nb de fichier max
			duree = 0 -- lire sd remettre duree a jour
			fich = valeur -- assigner valeur
		end
		if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
			valeur = choose(valeur,1,nbfile,-1)
			duree = 0 -- lire sd remettre duree a jour
			fich = valeur -- assigner valeur
		end
				
	
	end

else ------ affiche valeur non selectionne -----
lcd.drawText(20, 1, fich , 0) --   n° session 
end






lcd.drawText(101, 1, math.floor(duree/120) .. " min" , SMLSIZE) -- durée log session



if rot==2 then -------------- modif item a afficher
------ affiche valeur selectionnne -----
lcd.drawText(1, 57, interval , SMLSIZE+INVERS) -- minute session affiché (0= de 0 a 1 min)

	if modif == rot then -- si mode modif sur cet item
	valeur = interval -- lire valeur
		
		if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
			valeur = choose(valeur,0,math.floor(duree/120),1) -- intervale minute de 0 a interval max fichier
			debut = 0 -- lire sd
		end
		if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
			valeur = choose(valeur,0,math.floor(duree/120),-1)
			debut = 0 -- lire sd
		end
				
	interval = valeur -- assigner valeur
	end

else ------ affiche valeur non selectionne -----
lcd.drawText(1, 57, interval , SMLSIZE) -- minute session affiché (0= de 0 a 1 min)
end







if curs > z-2 then -- limite max curseur
curs = z-2
end



lcd.drawText(lcd.getLastPos()+1, 57, ":" , SMLSIZE) -- 



if rot==3 then -------------- modif item a afficher
------ affiche valeur selectionnne -----
lcd.drawText(lcd.getLastPos()+1, 57, curs/2 .. " s" , SMLSIZE+INVERS) -- curseur tps en sec par pas de 0.5s

	if modif == rot then -- si mode modif sur cet item
	valeur = curs -- lire valeur
		
		
		
		if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
		
			if getRotEncSpeed() == ROTENC_HIGHSPEED then
			valeur = choose(valeur,0,(z-2),10) -- curseur tps de 0 a 119
			elseif getRotEncSpeed() == ROTENC_MIDSPEED then 
			valeur = choose(valeur,0,(z-2),5) -- curseur tps de 0 a 119
			else
			valeur = choose(valeur,0,(z-2),1) -- curseur tps de 0 a 119
			end
			
		end
		if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
		
			if getRotEncSpeed() == ROTENC_HIGHSPEED then
			valeur = choose(valeur,0,(z-2),-10) -- curseur tps de 0 a 119
			elseif getRotEncSpeed() == ROTENC_MIDSPEED then 
			valeur = choose(valeur,0,(z-2),-5) -- curseur tps de 0 a 119
			else
			valeur = choose(valeur,0,(z-2),-1) -- curseur tps de 0 a 119
			end
			
		end
				
	curs = valeur -- assigner valeur
	end

else ------ affiche valeur non selectionne -----
lcd.drawText(lcd.getLastPos()+1, 57, curs/2 .. " s" , SMLSIZE) -- curseur tps en sec par pas de 0.5s
end





 lcd.drawLine(curs,10,curs,54, SOLID, FORCE) -- ligne curseur tps



if rot==4 then -------------- modif item a afficher
------ affiche valeur selectionnne -----
lcd.drawText(45, 57, string.sub(item,1,4) , SMLSIZE+INVERS) -- item log choisi

	if modif == rot then -- si mode modif sur cet item
	valeur = numitem -- lire valeur
		
		if event == EVT_VIRTUAL_NEXT then -- bouton rotary next 
			valeur = choose(valeur,3,54,1) -- les 2 premier numitem ne sont pas des nombre donc commence a 3
			debut = 0 -- lire sd
		end
		if event == EVT_VIRTUAL_PREV then -- bouton rotary next 
			valeur = choose(valeur,3,54,-1) 
			debut = 0 -- lire sd
		end
				
	numitem = valeur -- assigner valeur
	end

else ------ affiche valeur non selectionne -----
lcd.drawText(45, 57, string.sub(item,1,4) , SMLSIZE) -- item log choisi
end


lcd.drawText(lcd.getLastPos()+3, 57, item_val[curs+1]*mult[reper] .. " " .. unit[reper], SMLSIZE) -- valeur item  -   multiplicateur 



-- assigner reper en fonction de num item =
if numitem >=3 and numitem <= 10 then
	reper = numitem -2
elseif numitem >= 11 and numitem <= 12 then
	reper = 9
elseif numitem >= 13 and numitem <= 16 then
	reper = 10
elseif numitem >= 17 and numitem <= 21 then
	reper = 11	
elseif numitem >= 22 and numitem <= 53 then
	reper = 12
else
	reper = 13
end




-- tracage 0 grap =
if math.floor((ori[reper]+curvdec[reper])*curvmult[reper]) <= 45 and math.floor((ori[reper]+curvdec[reper])*curvmult[reper]) >= 0 then
 lcd.drawLine(122,54-math.floor((ori[reper]+curvdec[reper])*curvmult[reper]),127,54-math.floor((ori[reper]+curvdec[reper])*curvmult[reper]), SOLID, FORCE) -- ligne curseur tps
	if math.floor((ori[reper]+curvdec[reper])*curvmult[reper]) >= 35  then
	lcd.drawText(123, 56-math.floor((ori[reper]+curvdec[reper])*curvmult[reper]), orival[reper] , SMLSIZE) -- valeur 0
	else
	lcd.drawText(123, 47-math.floor((ori[reper]+curvdec[reper])*curvmult[reper]), orival[reper] , SMLSIZE) -- valeur 0
	end
end





-- tracage graph :
for i = 1,(z-1) do

	if math.floor((item_val[i]+curvdec[reper])*curvmult[reper]) <= 45 and math.floor((item_val[i]+curvdec[reper])*curvmult[reper]) >= 0 then -- si dans limite graph

	lcd.drawPoint( i-1,54-math.floor((item_val[i]+curvdec[reper])*curvmult[reper]) ) --  multiplicateur  et decalage 
	
	end
end


  
  -- page:
lcd.drawNumber(123, 57,"6", 0+INVERS) -- texte numero page

end