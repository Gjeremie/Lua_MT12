local shared = ...

local fich1 = "/SCRIPTS/TELEMETRY/" .. string.sub(model.getInfo().name,1,1) .. "-log.txt"
local pag = 1 -- numero de session  (de 1 a 180) 90 sessions
local refresh = 1 -- rafraichir lecture session

local timesess = "0" -- tps de session en seconde
local repet = 0 -- cadence lecture carte sd
local tour = {"0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"} -- table de tps au tour (table commence a 1) attention tour 0 est stocké dans tour[1]
local top    -- meilleur tour
local topn  = 0  -- numero meilleur tour
local dat = {"0","0","0","0"} -- date

local capa = 0 -- en mA/h - variable capacité calculé
local tempM = 0 -- en °C - variable temperature MAX calculé
local voltM = 0 -- en centiv - variable tension lipo MIN calculé 
local courantM = 0  -- en A - variable courant max
local volt = 0  -- en centiv - variable tension lipo live

local function lap(num,best,t) -- num: num de tour      best: affiche best si 1      t: tps au tour
local colonne

if (t>0) then -- si tour pas vide
			if num <12 then -- si premier groupe de 12 tour
				if (num<6) then
					colonne = 0
					else
					colonne = 43
				end
				
				lcd.drawNumber(3 + colonne, 1 + 11 * num - 66  * math.floor(0.16* num +0.14), num, 0+INVERS) -- numero lap
				
			else -- si 2eme groupe de 12 tour
				if (num<18) then
					colonne = 0
					else
					colonne = 43
				end
				
				num = num - 12 -- decaler num pour considerer premier groupe
				lcd.drawNumber(3 + colonne, 1 + 11 * num - 66  * math.floor(0.16* num +0.14), num+12, 0+INVERS) -- numero lap avec affichage corrigé + 12
				
			end
			
			
			
			
			lcd.drawNumber(20 + colonne, 1 + 11 * num - 66  * math.floor(0.16* num +0.14), math.floor(math.fmod(t/100,60)), 0) -- tps tour -- seconde
			lcd.drawNumber(32 + colonne, 1 + 11 * num - 66  * math.floor(0.16* num +0.14), math.fmod(t,100), 0) -- tps tour -- centieme

			if (math.floor(t/100/60)>0) then -- si minute pas vide
			lcd.drawNumber(13 + colonne, 1 + 11 * num - 66  * math.floor(0.16* num +0.14), math.floor(t/100/60), 0) -- tps tour -- minute

			lcd.drawLine(colonne+18, 2 + 11 * num - 66  * math.floor(0.16* num +0.14), colonne+18, 3 + 11 * num - 66  * math.floor(0.16* num +0.14)      , SOLID, FORCE)-- trait entre min et sec
			lcd.drawLine(colonne+18, 5 + 11 * num - 66  * math.floor(0.16* num +0.14), colonne+18, 6 + 11 * num - 66  * math.floor(0.16* num +0.14)      , SOLID, FORCE)-- trait entre min et sec
			end

			lcd.drawLine(colonne+30, 2+ 11 * num - 66  * math.floor(0.16* num +0.14), colonne+30, 3 + 11 * num - 66  * math.floor(0.16* num +0.14)      , SOLID, FORCE)-- trait entre sec et cent
			lcd.drawLine(colonne+30, 5 + 11 * num - 66  * math.floor(0.16* num +0.14), colonne+30, 6 + 11 * num - 66  * math.floor(0.16* num +0.14)      , SOLID, FORCE)-- trait entre sec et cent

			if (best==1) then
			lcd.drawLine(colonne,   11 * num - 66  * math.floor(0.16* num +0.14), colonne, 8+ 11* num - 66  * math.floor(0.16* num +0.14)      , SOLID, ERASE)-- trait best lap
			lcd.drawLine(colonne+1,   11 * num - 66  * math.floor(0.16* num +0.14), colonne+1, 8+ 11* num - 66  * math.floor(0.16* num +0.14)      , SOLID, ERASE)-- trait best lap
			end
			
			if ((num>0 and num<6) or (num>6 and num<12)) then
			lcd.drawLine(colonne,   -2+11 * num - 66  * math.floor(0.16* num +0.14), colonne, -1+ 11* num - 66  * math.floor(0.16* num +0.14)      , SOLID, FORCE)-- trait completer
			lcd.drawLine(colonne+1,  -2+ 11 * num - 66  * math.floor(0.16* num +0.14), colonne+1, -1+ 11* num - 66  * math.floor(0.16* num +0.14)      , SOLID, FORCE)-- trait completer
			end
			
	end

end



function shared.run(event)
  lcd.clear()

  
  

  
---- touche bascule entre ecran -----------------
 if event == EVT_VIRTUAL_MENU then -- bouton menu 
 playTone(1200, 120,5) -- play tone
    shared.changeScreen(4)
  end
  
 if event == EVT_VIRTUAL_MENU_LONG then -- bouton menu 
 playTone(1200, 120,5) -- play tone
    shared.changeScreen(5)
  end


---- DEBUT fond ------------

lcd.drawLine(0,0,0,63, SOLID, FORCE)
lcd.drawLine(1,0,1,63, SOLID, FORCE)
lcd.drawLine(43,0,43,63, SOLID, FORCE)
lcd.drawLine(44,0,44,63, SOLID, FORCE)


lcd.drawLine(111,6,115,2, SOLID, FORCE)
lcd.drawFilledRectangle(87, 0, 10, 20, FORCE)

lcd.drawLine(113,13,114,13, SOLID, FORCE)
lcd.drawLine(98,19,127,19, SOLID, FORCE)
lcd.drawLine(86,0,86,63, SOLID, FORCE)
lcd.drawLine(97,0,97,63, SOLID, FORCE)
lcd.drawLine(112,10,112,16, SOLID, FORCE)
lcd.drawLine(115,10,115,16, SOLID, FORCE)

lcd.drawPoint(89,1)
lcd.drawPoint(93,1)
lcd.drawLine(87,2,88,2, SOLID, ERASE)
lcd.drawLine(90,2,92,2, SOLID, ERASE)
lcd.drawLine(94,2,95,2, SOLID, ERASE)
lcd.drawLine(87,8,95,8, SOLID, ERASE)
lcd.drawLine(87,3,87,7, SOLID, ERASE)
lcd.drawLine(95,3,95,7, SOLID, ERASE)

lcd.drawFilledRectangle(87,20,10,44,FORCE)

---- FIN fond ------------




---- touche ROTARY -----------------
if event == EVT_VIRTUAL_NEXT then -- bouton rotary 
    if getRotEncSpeed() == ROTENC_HIGHSPEED then -- rapide
		pag = pag+4
				
		elseif getRotEncSpeed() == ROTENC_MIDSPEED then -- moyen
		pag = pag+2
				
		else -- lent
				
		pag = pag+1
	end
	
	if (pag >180) then
	pag =180
	else
	playTone(1200, 50,5) -- play tone
	refresh = 1
	end
  end

if event == EVT_VIRTUAL_PREV then -- bouton rotary 
    if getRotEncSpeed() == ROTENC_HIGHSPEED then -- rapide
		pag = pag-4
				
		elseif getRotEncSpeed() == ROTENC_MIDSPEED then -- moyen
		pag = pag-2
				
		else -- lent
				
		pag = pag-1
	end
	
	if (pag <1) then
	pag =1
	else
	playTone(1200, 50,5) -- play tone
	refresh = 1
	end
  end
  
if event == EVT_VIRTUAL_ENTER then -- bouton rotary 
    
	if pag ==1 then
	else
	 playTone(1200, 120,5) -- play tone
	 refresh = 1
	end
	pag = 1
  end

 lcd.drawNumber(87, 10, math.floor(pag/2+0.5), 0+INVERS) -- afficher numero de session

 

 ---- ================ recup SD toute les ...  ===============
 if (getTime()> (50+ repet) ) or refresh == 1 then -- A FAIRE TOUTE LES :    50 x 10ms = 0.5s
 

local file = io.open(fich1, "r") -- ouvrir fichier 0-log.txt en acces lecture


 -- recup date -----------
 	
	local curs = io.seek(file, 1 +176 * (math.floor(pag/2+0.5) -1)) --  positionner curseur dans fichier log - lecture date
	 dat[1] = io.read (file, 2) -- lire 2 carac de  dans fichier log et asssigner a table date

	 local curs = io.seek(file, 1 +176 * (math.floor(pag/2+0.5) -1) +2) --  positionner curseur dans fichier log - lecture date
	 dat[2] = io.read (file, 2) -- lire 2 carac de  dans fichier log et asssigner a table date
	 
	 local curs = io.seek(file, 1 +176 * (math.floor(pag/2+0.5) -1) +4) --  positionner curseur dans fichier log - lecture date
	 dat[3] = io.read (file, 2) -- lire 2 carac de  dans fichier log et asssigner a table date
	 
	 local curs = io.seek(file, 1 +176 * (math.floor(pag/2+0.5) -1) +6) --  positionner curseur dans fichier log - lecture date
	 dat[4] = io.read (file, 2) -- lire 2 carac de  dans fichier log et asssigner a table date


 -- recup tps de session de log sd -----------
	local curs = io.seek(file, 1 +176 * (math.floor(pag/2+0.5) -1) +8) --  positionner curseur dans fichier log - lecture tps session
	 timesess = io.read (file, 4) -- lire 4 carac   dans fichier log et asssigner a timesess
	 
	 
 -- recup les tps au tour  -----------
 
	for i = 0,23 do
		
		local curs = io.seek(file, 1 +176 * (math.floor(pag/2+0.5) -1) +32 + i*6) --  positionner curseur dans fichier log - lecture tour
		 tour[i+1] = io.read (file, 6) -- lire 6 carac de  dans fichier log et asssigner a table tour
		 
			 
			 tour[i+1] = tostring(tour[i+1])  -- convertir en string
		tour[i+1] = string.gsub(tour[i+1],"x","")  -- enlever les xx et convertir en nombre

		if (tour[i+1]=="") then -- variable vide
			tour[i+1] = "0"  -- mettre variable a zero
		end

		tour[i+1] = tonumber(tour[i+1]) -- convertir en nombre
		
	end


 -- recup tension mini lipo -----------
	local curs = io.seek(file, 1 +176 * (math.floor(pag/2+0.5) -1) +12) --  positionner curseur dans fichier log 
	 voltM = io.read (file, 3) -- lire 3 carac   dans fichier log et asssigner
	 
 -- recup temperature max -----------
	local curs = io.seek(file, 1 +176 * (math.floor(pag/2+0.5) -1) +18) --  positionner curseur dans fichier log 
	 tempM = io.read (file, 3) -- lire 3 carac   dans fichier log et asssigner	 
	
 -- recup capacité conso -----------
	local curs = io.seek(file, 1 +176 * (math.floor(pag/2+0.5) -1) +15) --  positionner curseur dans fichier log 
	 capa = io.read (file, 3) -- lire 3 carac   dans fichier log et asssigner		

 -- recup courant max -----------
	local curs = io.seek(file, 1 +176 * (math.floor(pag/2+0.5) -1) +24) --  positionner curseur dans fichier log 
	 courantM = io.read (file, 3) -- lire 3 carac   dans fichier log et asssigner	 
	 
	  -- recup volt live fin de pack -----------
	local curs = io.seek(file, 1 +176 * (math.floor(pag/2+0.5) -1) +21) --  positionner curseur dans fichier log 
	 volt = io.read (file, 3) -- lire 3 carac   dans fichier log et asssigner	 


io.close(file) -- fermer fichier log
	

	-- ==================FORMATAGE DATA==========================
	
-- tps session  ---------
	timesess = tostring(timesess)  -- convertir en string
	
timesess = string.gsub(timesess,"x","")  -- enlever les xx 
	
if (timesess=="") then -- variable non assigné
	timesess = "0"  -- mettre variable a zero
end

timesess = tonumber(timesess) -- convertir en nombre
	
		
		
-- date session -----------
for i = 1,4 do  -- balayer les date et formater
	dat[i] = tostring(dat[i])  -- convertir en string
		
	dat[i] = string.gsub(dat[i],"x","")  -- enlever les xx 
		
	if (dat[i]=="") then -- variable non assigné
		dat[i] = "0"  -- mettre variable a zero
	end
end	
	
	
	
-- tension mini lipo  ---------
voltM = tostring(voltM)  -- convertir en string
voltM = string.gsub(voltM,"x","")  -- enlever les xx 
if (voltM=="") then -- variable non assigné
	voltM = "0"  -- mettre variable a zero
end
voltM = tonumber(voltM) -- convertir en nombre


	
-- courant max  ---------
courantM = tostring(courantM)  -- convertir en string
courantM = string.gsub(courantM,"x","")  -- enlever les xx 
if (courantM=="") then -- variable non assigné
	courantM = "0"  -- mettre variable a zero
end
courantM = tonumber(courantM) -- convertir en nombre

-- tension live lipo  ---------
volt = tostring(volt)  -- convertir en string
volt = string.gsub(volt,"x","")  -- enlever les xx 
if (volt=="") then -- variable non assigné
	volt = "0"  -- mettre variable a zero
end
volt = tonumber(volt) -- convertir en nombre

-- temperature max  ---------
tempM = tostring(tempM)  -- convertir en string
tempM = string.gsub(tempM,"x","")  -- enlever les xx 
if (tempM=="") then -- variable non assigné
	tempM = "0"  -- mettre variable a zero
end
tempM = tonumber(tempM) -- convertir en nombre


-- capacité conso  ---------
capa = tostring(capa)  -- convertir en string
capa = string.gsub(capa,"x","")  -- enlever les xx 
if (capa=="") then -- variable non assigné
	capa = "0"  -- mettre variable a zero
end
capa = tonumber(capa) -- convertir en nombre


	
	
	-- =================================================
repet =  getTime() -- init  tps
refresh = 0 -- init refresh
end



------- Affiche ---------- date session


lcd.drawText(100, 1, dat[1] , 0) -- valeur avec sa  corrigé
lcd.drawText(118, 1, dat[2] , 0) -- valeur avec sa  corrigé

lcd.drawText(100, 10, dat[3] , 0) -- valeur avec sa  corrigé
lcd.drawText(119, 10, dat[4] , 0) -- valeur avec sa  corrigé
 
 


--------- Affiche ----------   lap ---------

top = 60000 -- assigner  meilleur tour a bcp

for i = 0,23 do  -- balayer les 24 tours recherche meilleur

if (tour[i+1]>0) then
	if (tour[i+1]<top) then
	
	top = tour[i+1]
	topn = i
	end
end

 end



 
  
 
 if math.fmod(pag,2) == 1 then -- affiche premiere page de la session ----------------------------------
 
  lcd.drawPoint(89,4)
  lcd.drawPoint(91,4)
  lcd.drawPoint(93,4)
 

 
 
lcd.drawLine(90,20,92,20, SOLID, ERASE)
lcd.drawPoint(89,21)
lcd.drawPoint(93,21)
lcd.drawLine(90,24,91,24, SOLID, ERASE)
lcd.drawPoint(89,27)
lcd.drawPoint(93,27)
lcd.drawLine(90,28,92,28, SOLID, ERASE)
lcd.drawPoint(93,31)
lcd.drawPoint(90,39)
lcd.drawLine(91,50,92,50, SOLID, ERASE)
lcd.drawLine(89,53,90,53, SOLID, ERASE)
lcd.drawPoint(90,55)
lcd.drawPoint(90,57)
lcd.drawPoint(93,57)
lcd.drawPoint(96,57)
lcd.drawPoint(88,61)
lcd.drawPoint(91,61)
lcd.drawLine(89,62,90,62, SOLID, ERASE)
lcd.drawLine(87,23,87,25, SOLID, ERASE)
lcd.drawLine(87,59,87,60, SOLID, ERASE)
lcd.drawLine(88,21,88,22, SOLID, ERASE)
lcd.drawLine(88,26,88,27, SOLID, ERASE)
lcd.drawLine(88,54,88,58, SOLID, ERASE)
lcd.drawLine(89,43,89,50, SOLID, ERASE)
lcd.drawLine(90,34,90,35, SOLID, ERASE)
lcd.drawLine(90,42,90,45, SOLID, ERASE)
lcd.drawLine(90,49,90,50, SOLID, ERASE)
lcd.drawLine(91,22,91,23, SOLID, ERASE)
lcd.drawLine(91,33,91,35, SOLID, ERASE)
lcd.drawLine(91,37,91,38, SOLID, ERASE)
lcd.drawLine(91,42,91,44, SOLID, ERASE)
lcd.drawLine(91,46,91,48, SOLID, ERASE)
lcd.drawLine(91,54,91,58, SOLID, ERASE)
lcd.drawLine(92,32,92,33, SOLID, ERASE)
lcd.drawLine(92,35,92,37, SOLID, ERASE)
lcd.drawLine(92,42,92,44, SOLID, ERASE)
lcd.drawLine(92,46,92,48, SOLID, ERASE)
lcd.drawLine(92,59,92,60, SOLID, ERASE)
lcd.drawLine(93,35,93,36, SOLID, ERASE)
lcd.drawLine(93,43,93,50, SOLID, ERASE)
lcd.drawLine(94,21,94,22, SOLID, ERASE)
lcd.drawLine(94,26,94,27, SOLID, ERASE)
lcd.drawLine(94,56,94,60, SOLID, ERASE)
lcd.drawLine(95,23,95,25, SOLID, ERASE)
lcd.drawLine(95,56,95,60, SOLID, ERASE)


lcd.drawPoint(120,38)
lcd.drawPoint(122,38)
lcd.drawPoint(121,39)
lcd.drawLine(120,44,121,44, SOLID, FORCE)
lcd.drawLine(120,47,121,47, SOLID, FORCE)
lcd.drawLine(125,47,126,47, SOLID, FORCE)
lcd.drawLine(117,54,119,54, SOLID, FORCE)
lcd.drawPoint(117,55)
lcd.drawPoint(119,55)
lcd.drawLine(117,56,119,56, SOLID, FORCE)
lcd.drawLine(111,23,111,24, SOLID, FORCE)
lcd.drawLine(111,26,111,27, SOLID, FORCE)
lcd.drawLine(119,33,119,37, SOLID, FORCE)
lcd.drawLine(119,45,119,50, SOLID, FORCE)
lcd.drawLine(122,45,122,50, SOLID, FORCE)
lcd.drawLine(123,33,123,37, SOLID, FORCE)
lcd.drawLine(124,44,124,50, SOLID, FORCE)
lcd.drawLine(127,44,127,50, SOLID, FORCE)

 
------ affiche lap ---
 for i = 0,11 do  -- balayer les 12 premier tours

if ( i == topn ) then
top = 1
else
top = 0
end

  lap(i,top,tour[i+1])

 end
  
 
--------- Affiche ---------- tps session
lcd.drawNumber(100, 22, math.floor(timesess/60) , 0 ) -- minute tps ecoulé timer 1
lcd.drawNumber(114, 22, math.floor(math.fmod(timesess,60)) , 0 ) -- seconde tps ecoulé timer 1
 

    --------- Affiche ---------- tension live fin pack lipo 
 lcd.drawNumber(100, 33, volt , 0+PREC2 ) -- tension  lipo format 3.75 V




--------- Affiche ----------  temperature max
lcd.drawNumber(100, 55, tempM , 0 ) -- temperature max



--------- Affiche ----------  capacité conso
lcd.drawNumber(100, 44, capa , 0+PREC2 ) -- capapacité consommé format 4.20  (= 4.20Ah)

 
 
 
else -- affiche 2eme page de la session ---------------------------------------
 
  lcd.drawPoint(89,6)
  lcd.drawPoint(91,6)
  lcd.drawPoint(93,6)
 
lcd.drawLine(89,21,90,21, SOLID, ERASE)
lcd.drawPoint(91,22)
lcd.drawPoint(93,24)
lcd.drawPoint(96,24)
lcd.drawPoint(91,27)
lcd.drawLine(89,28,90,28, SOLID, ERASE)
lcd.drawPoint(90,31)
lcd.drawPoint(93,37)
lcd.drawPoint(96,37)
lcd.drawPoint(87,39)
lcd.drawLine(87,23,87,26, SOLID, ERASE)
lcd.drawLine(87,34,87,35, SOLID, ERASE)
lcd.drawLine(88,22,88,27, SOLID, ERASE)
lcd.drawLine(88,33,88,35, SOLID, ERASE)
lcd.drawLine(88,37,88,38, SOLID, ERASE)
lcd.drawLine(89,32,89,33, SOLID, ERASE)
lcd.drawLine(89,35,89,37, SOLID, ERASE)
lcd.drawLine(90,35,90,36, SOLID, ERASE)
lcd.drawLine(94,23,94,27, SOLID, ERASE)
lcd.drawLine(94,34,94,38, SOLID, ERASE)
lcd.drawLine(95,23,95,27, SOLID, ERASE)
lcd.drawLine(95,34,95,38, SOLID, ERASE)


lcd.drawLine(120,22,121,22, SOLID, FORCE)
lcd.drawLine(120,25,121,25, SOLID, FORCE)
lcd.drawPoint(120,38)
lcd.drawPoint(122,38)
lcd.drawPoint(121,39)
lcd.drawLine(119,23,119,28, SOLID, FORCE)
lcd.drawLine(119,33,119,37, SOLID, FORCE)
lcd.drawLine(122,23,122,28, SOLID, FORCE)
lcd.drawLine(123,33,123,37, SOLID, FORCE)

 
 
 
 ------ affiche lap ---
 for i = 12,23 do  -- balayer les 12 premier tours

if ( i == topn ) then
top = 1
else
top = 0
end

  lap(i,top,tour[i+1])

 end
  
  --------- Affiche ---------- courant max
  lcd.drawNumber(100, 22, courantM , 0 ) -- courant max
  
 
  --------- Affiche ---------- tension mini lipo 
lcd.drawNumber(100, 33, voltM , 0+PREC2 ) -- tension mini lipo format 3.73 V
 
  
 end
  
-- page:
lcd.drawNumber(123, 56,"2", 0+INVERS) -- texte numero page


if (shared.pop == 1 ) then -- si reset session

popupWarning("Nouvelle Session", 0)

end



end