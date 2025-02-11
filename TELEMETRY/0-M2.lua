local shared = ...

local fich1 = "/SCRIPTS/TELEMETRY/" .. string.sub(model.getInfo().name,1,1) .. "-log.txt"
local pag = 1 -- numero de session  (de 1 a 60)
local colonne
local timesess = "0" -- tps de session en seconde
local repet = 0 -- cadence lecture carte sd
local tour = {"0","0","0","0","0","0","0","0","0","0","0","0","0"} -- table de tps au tour (table commence a 1) attention tour 0 est stocké dans tour[1]
local top    -- meilleur tour
local topn  = 0  -- numero meilleur tour
local dat = {"0","0","0","0"} -- date

local capa = 0 -- en mA/h - variable capacité calculé
local tempM = 0 -- en °C - variable temperature MAX calculé
local voltM = 0 -- en centiv - variable tension lipo MIN calculé 
local courantM = 0  -- en A - variable courant max
local volt = 0  -- en centiv - variable tension lipo live

local function lap(num,best,t)

if (t>0) then -- si tour pas vide
			if (num<6) then
			colonne = 0
			else
			colonne = 43
			end

			lcd.drawNumber(3 + colonne, 1 + 11 * num - 66  * math.floor(0.16* num +0.14), num, 0+INVERS) -- numero lap
			lcd.drawNumber(20 + colonne, 1 + 11 * num - 66  * math.floor(0.16* num +0.14), math.floor(math.fmod(t/100,60)), 0) -- tps tour -- seconde
			lcd.drawNumber(32 + colonne, 1 + 11 * num - 66  * math.floor(0.16* num +0.14), math.fmod(t,100), 0) -- tps tour -- centieme

			if (math.floor(t/100/60)>0) then -- si minute pas vide
			lcd.drawNumber(13 + colonne, 1 + 11 * num - 66  * math.floor(0.16* num +0.14), math.floor(t/100/60), 0) -- tps tour -- minute

			lcd.drawLine(colonne+18, 2 + 11 * num - 66  * math.floor(0.16* num +0.14), colonne+18, 3 + 11 * num - 66  * math.floor(0.16* num +0.14)      , SOLID, FORCE)-- trait entre min et sec
			lcd.drawLine(colonne+18, 5 + 11 * num - 66  * math.floor(0.16* num +0.14), colonne+18, 6 + 11 * num - 66  * math.floor(0.16* num +0.14)      , SOLID, FORCE)-- trait entre min et sec
			end

			lcd.drawLine(colonne+30, 2+ 11 * num - 66  * math.floor(0.16* num +0.14), colonne+30, 3 + 11 * num - 66  * math.floor(0.16* num +0.14)      , SOLID, FORCE)-- trait entre sec et cent
			lcd.drawLine(colonne+30, 5 + 11 * num - 66  * math.floor(0.16* num +0.14), colonne+30, 6 + 11 * num - 66  * math.floor(0.16* num +0.14)      , SOLID, FORCE)-- trait entre sec et cent

			if (best==0) then
			lcd.drawLine(colonne,   11 * num - 66  * math.floor(0.16* num +0.14), colonne, 8+ 11* num - 66  * math.floor(0.16* num +0.14)      , SOLID, FORCE)-- trait best lap
			lcd.drawLine(colonne+1,   11 * num - 66  * math.floor(0.16* num +0.14), colonne+1, 8+ 11* num - 66  * math.floor(0.16* num +0.14)      , SOLID, FORCE)-- trait best lap
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

lcd.drawLine(87,0,95,0, SOLID, FORCE)
lcd.drawLine(87,1,88,1, SOLID, FORCE)
lcd.drawLine(90,1,92,1, SOLID, FORCE)
lcd.drawLine(94,1,95,1, SOLID, FORCE)
lcd.drawPoint(89,2)
lcd.drawPoint(93,2)
lcd.drawPoint(115,2)
lcd.drawLine(88,3,94,3, SOLID, FORCE)
lcd.drawPoint(114,3)
lcd.drawPoint(113,4)
lcd.drawPoint(89,5)
lcd.drawPoint(91,5)
lcd.drawPoint(93,5)
lcd.drawPoint(112,5)
lcd.drawPoint(111,6)
lcd.drawLine(88,7,94,7, SOLID, FORCE)
lcd.drawLine(87,9,95,9, SOLID, FORCE)
lcd.drawLine(113,13,114,13, SOLID, FORCE)
lcd.drawLine(87,17,91,17, SOLID, FORCE)
lcd.drawLine(87,18,91,18, SOLID, FORCE)
lcd.drawLine(87,19,91,19, SOLID, FORCE)
lcd.drawLine(98,19,127,19, SOLID, FORCE)
lcd.drawLine(86,0,86,63, SOLID, FORCE)
lcd.drawLine(88,4,88,6, SOLID, FORCE)
lcd.drawLine(90,4,90,6, SOLID, FORCE)
lcd.drawLine(92,4,92,6, SOLID, FORCE)
lcd.drawLine(92,10,92,19, SOLID, FORCE)
lcd.drawLine(93,10,93,19, SOLID, FORCE)
lcd.drawLine(94,4,94,6, SOLID, FORCE)
lcd.drawLine(94,10,94,19, SOLID, FORCE)
lcd.drawLine(95,10,95,19, SOLID, FORCE)
lcd.drawLine(96,0,96,19, SOLID, FORCE)
lcd.drawLine(97,0,97,63, SOLID, FORCE)
lcd.drawLine(112,10,112,16, SOLID, FORCE)
lcd.drawLine(115,10,115,16, SOLID, FORCE)

---- FIN fond ------------




---- touche ROTARY -----------------
if event == EVT_VIRTUAL_NEXT then -- bouton rotary 
    pag = pag+1
	
	if (pag >60) then
	pag =60
	else
	playTone(1200, 50,5) -- play tone
	end
  end

if event == EVT_VIRTUAL_PREV then -- bouton rotary 
    pag = pag-1
	
	if (pag <1) then
	pag =1
	else
	playTone(1200, 50,5) -- play tone
	end
  end
  
if event == EVT_VIRTUAL_ENTER then -- bouton rotary 
    
	if pag ==1 then
	else
	 playTone(1200, 120,5) -- play tone
	 
	end
	pag = 1
  end

 lcd.drawNumber(87, 10, math.floor(pag/2+0.5), 0+INVERS) -- afficher numero de session

 

 ---- ================ recup SD toute les ...  ===============
 if (getTime()> (50+ repet) ) then -- A FAIRE TOUTE LES :    100 x 10ms = 1s
 

local file = io.open(fich1, "r") -- ouvrir fichier 0-log.txt en acces lecture


 -- recup date -----------
 	
	local curs = io.seek(file, 1 +104 * (math.floor(pag/2+0.5) -1)) --  positionner curseur dans fichier log - lecture date
	 dat[1] = io.read (file, 2) -- lire 2 carac de  dans fichier log et asssigner a table date

	 local curs = io.seek(file, 1 +104 * (math.floor(pag/2+0.5) -1) +2) --  positionner curseur dans fichier log - lecture date
	 dat[2] = io.read (file, 2) -- lire 2 carac de  dans fichier log et asssigner a table date
	 
	 local curs = io.seek(file, 1 +104 * (math.floor(pag/2+0.5) -1) +4) --  positionner curseur dans fichier log - lecture date
	 dat[3] = io.read (file, 2) -- lire 2 carac de  dans fichier log et asssigner a table date
	 
	 local curs = io.seek(file, 1 +104 * (math.floor(pag/2+0.5) -1) +6) --  positionner curseur dans fichier log - lecture date
	 dat[4] = io.read (file, 2) -- lire 2 carac de  dans fichier log et asssigner a table date


 -- recup tps de session de log sd -----------
	local curs = io.seek(file, 1 +104 * (math.floor(pag/2+0.5) -1) +8) --  positionner curseur dans fichier log - lecture tps session
	 timesess = io.read (file, 4) -- lire 4 carac   dans fichier log et asssigner a timesess
	 
	 
 -- recup les tps au tour  -----------
 
	for i = 0,11 do
		
		local curs = io.seek(file, 1 +104 * (math.floor(pag/2+0.5) -1) +32 + i*6) --  positionner curseur dans fichier log - lecture tour
		 tour[i+1] = io.read (file, 6) -- lire 6 carac de  dans fichier log et asssigner a table tour
		 
			 
			 tour[i+1] = tostring(tour[i+1])  -- convertir en string
		tour[i+1] = string.gsub(tour[i+1],"x","")  -- enlever les xx et convertir en nombre

		if (tour[i+1]=="") then -- variable vide
			tour[i+1] = "0"  -- mettre variable a zero
		end

		tour[i+1] = tonumber(tour[i+1]) -- convertir en nombre
		
	end


 -- recup tension mini lipo -----------
	local curs = io.seek(file, 1 +104 * (math.floor(pag/2+0.5) -1) +12) --  positionner curseur dans fichier log 
	 voltM = io.read (file, 3) -- lire 3 carac   dans fichier log et asssigner
	 
 -- recup temperature max -----------
	local curs = io.seek(file, 1 +104 * (math.floor(pag/2+0.5) -1) +18) --  positionner curseur dans fichier log 
	 tempM = io.read (file, 3) -- lire 3 carac   dans fichier log et asssigner	 
	
 -- recup capacité conso -----------
	local curs = io.seek(file, 1 +104 * (math.floor(pag/2+0.5) -1) +15) --  positionner curseur dans fichier log 
	 capa = io.read (file, 3) -- lire 3 carac   dans fichier log et asssigner		

 -- recup courant max -----------
	local curs = io.seek(file, 1 +104 * (math.floor(pag/2+0.5) -1) +24) --  positionner curseur dans fichier log 
	 courantM = io.read (file, 3) -- lire 3 carac   dans fichier log et asssigner	 
	 
	  -- recup volt live fin de pack -----------
	local curs = io.seek(file, 1 +104 * (math.floor(pag/2+0.5) -1) +21) --  positionner curseur dans fichier log 
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
end



------- Affiche ---------- date session


lcd.drawText(100, 1, dat[1] , 0) -- valeur avec sa  corrigé
lcd.drawText(118, 1, dat[2] , 0) -- valeur avec sa  corrigé

lcd.drawText(100, 10, dat[3] , 0) -- valeur avec sa  corrigé
lcd.drawText(119, 10, dat[4] , 0) -- valeur avec sa  corrigé
 
 


--------- Affiche ----------   lap ---------

top = 60000 -- assigner  meilleur tour a bcp

for i = 0,11 do  -- balayer les 11 tours recherche meilleur

if (tour[i+1]>0) then
	if (tour[i+1]<top) then
	
	top = tour[i+1]
	topn = i
	end
end

 end


for i = 0,11 do  -- balayer les 11 tours

if ( i == topn ) then
top = 1
else
top = 0
end

  lap(i,top,tour[i+1])

 end
 
  
 
 if math.fmod(pag,2) == 1 then -- affiche premiere page de la session ----------------------------------
 
 
 lcd.drawLine(88,20,89,20, SOLID, FORCE)
lcd.drawLine(93,20,94,20, SOLID, FORCE)
lcd.drawLine(90,21,92,21, SOLID, FORCE)
lcd.drawLine(89,22,90,22, SOLID, FORCE)
lcd.drawLine(92,22,93,22, SOLID, FORCE)
lcd.drawLine(88,23,90,23, SOLID, FORCE)
lcd.drawLine(92,23,94,23, SOLID, FORCE)
lcd.drawLine(88,24,89,24, SOLID, FORCE)
lcd.drawLine(92,24,94,24, SOLID, FORCE)
lcd.drawLine(88,25,94,25, SOLID, FORCE)
lcd.drawLine(89,26,93,26, SOLID, FORCE)
lcd.drawLine(90,27,92,27, SOLID, FORCE)
lcd.drawPoint(92,34)
lcd.drawPoint(91,36)
lcd.drawPoint(120,38)
lcd.drawPoint(122,38)
lcd.drawPoint(121,39)
lcd.drawLine(120,44,121,44, SOLID, FORCE)
lcd.drawLine(91,45,92,45, SOLID, FORCE)
lcd.drawLine(120,47,121,47, SOLID, FORCE)
lcd.drawLine(125,47,126,47, SOLID, FORCE)
lcd.drawLine(91,49,92,49, SOLID, FORCE)
lcd.drawPoint(90,54)
lcd.drawLine(117,54,119,54, SOLID, FORCE)
lcd.drawPoint(117,55)
lcd.drawPoint(119,55)
lcd.drawPoint(90,56)
lcd.drawLine(117,56,119,56, SOLID, FORCE)
lcd.drawPoint(87,61)
lcd.drawPoint(92,61)
lcd.drawLine(87,62,88,62, SOLID, FORCE)
lcd.drawLine(91,62,92,62, SOLID, FORCE)
lcd.drawLine(87,63,92,63, SOLID, FORCE)
lcd.drawLine(87,20,87,22, SOLID, FORCE)
lcd.drawLine(87,26,87,58, SOLID, FORCE)
lcd.drawLine(88,28,88,53, SOLID, FORCE)
lcd.drawLine(88,59,88,60, SOLID, FORCE)
lcd.drawLine(89,28,89,42, SOLID, FORCE)
lcd.drawLine(89,51,89,52, SOLID, FORCE)
lcd.drawLine(89,54,89,61, SOLID, FORCE)
lcd.drawLine(90,29,90,33, SOLID, FORCE)
lcd.drawLine(90,36,90,38, SOLID, FORCE)
lcd.drawLine(90,40,90,41, SOLID, FORCE)
lcd.drawLine(90,46,90,48, SOLID, FORCE)
lcd.drawLine(90,51,90,52, SOLID, FORCE)
lcd.drawLine(90,58,90,61, SOLID, FORCE)
lcd.drawLine(91,29,91,32, SOLID, FORCE)
lcd.drawLine(91,39,91,41, SOLID, FORCE)
lcd.drawLine(91,51,91,53, SOLID, FORCE)
lcd.drawLine(91,59,91,60, SOLID, FORCE)
lcd.drawLine(92,29,92,31, SOLID, FORCE)
lcd.drawLine(92,38,92,41, SOLID, FORCE)
lcd.drawLine(92,51,92,58, SOLID, FORCE)
lcd.drawLine(93,28,93,30, SOLID, FORCE)
lcd.drawLine(93,32,93,34, SOLID, FORCE)
lcd.drawLine(93,37,93,42, SOLID, FORCE)
lcd.drawLine(93,51,93,56, SOLID, FORCE)
lcd.drawLine(93,58,93,63, SOLID, FORCE)
lcd.drawLine(94,28,94,55, SOLID, FORCE)
lcd.drawLine(94,61,94,63, SOLID, FORCE)
lcd.drawLine(95,20,95,22, SOLID, FORCE)
lcd.drawLine(95,26,95,55, SOLID, FORCE)
lcd.drawLine(95,61,95,63, SOLID, FORCE)
lcd.drawLine(96,20,96,56, SOLID, FORCE)
lcd.drawLine(96,58,96,63, SOLID, FORCE)
lcd.drawLine(111,23,111,24, SOLID, FORCE)
lcd.drawLine(111,26,111,27, SOLID, FORCE)
lcd.drawLine(119,33,119,37, SOLID, FORCE)
lcd.drawLine(119,45,119,50, SOLID, FORCE)
lcd.drawLine(122,45,122,50, SOLID, FORCE)
lcd.drawLine(123,33,123,37, SOLID, FORCE)
lcd.drawLine(124,44,124,50, SOLID, FORCE)
lcd.drawLine(127,44,127,50, SOLID, FORCE)

 
  
 
--------- Affiche ---------- tps session
lcd.drawNumber(100, 22, math.floor(timesess/60) , 0 ) -- minute tps ecoulé timer 1
lcd.drawNumber(114, 22, math.floor(math.fmod(timesess,60)) , 0 ) -- seconde tps ecoulé timer 1
 

    --------- Affiche ---------- tension live fin pack lipo 
 lcd.drawNumber(100, 33, volt , 0+PREC2 ) -- tension  lipo format 3.75 V




--------- Affiche ----------  temperature max
lcd.drawNumber(100, 55, tempM , 0 ) -- temperature max



--------- Affiche ----------  capacité conso
lcd.drawNumber(100, 44, capa , 0+PREC2 ) -- capapacité consommé format 4.20  (= 4.20Ah)

 
 
 
else -- affiche deusieme page de la session ---------------------------------------
 
 
 lcd.drawLine(88,20,96,20, SOLID, FORCE)
lcd.drawPoint(88,21)
lcd.drawPoint(91,21)
lcd.drawLine(120,22,121,22, SOLID, FORCE)
lcd.drawLine(120,25,121,25, SOLID, FORCE)
lcd.drawPoint(89,34)
lcd.drawPoint(88,36)
lcd.drawPoint(120,38)
lcd.drawPoint(122,38)
lcd.drawPoint(121,39)
lcd.drawLine(87,20,87,22, SOLID, FORCE)
lcd.drawLine(87,27,87,33, SOLID, FORCE)
lcd.drawLine(87,36,87,38, SOLID, FORCE)
lcd.drawLine(87,40,87,63, SOLID, FORCE)
lcd.drawLine(88,28,88,32, SOLID, FORCE)
lcd.drawLine(88,39,88,63, SOLID, FORCE)
lcd.drawLine(89,22,89,27, SOLID, FORCE)
lcd.drawLine(89,29,89,31, SOLID, FORCE)
lcd.drawLine(89,38,89,63, SOLID, FORCE)
lcd.drawLine(90,22,90,27, SOLID, FORCE)
lcd.drawLine(90,29,90,30, SOLID, FORCE)
lcd.drawLine(90,32,90,34, SOLID, FORCE)
lcd.drawLine(90,37,90,63, SOLID, FORCE)
lcd.drawLine(91,23,91,26, SOLID, FORCE)
lcd.drawLine(91,28,91,63, SOLID, FORCE)
lcd.drawLine(92,21,92,63, SOLID, FORCE)
lcd.drawLine(93,21,93,23, SOLID, FORCE)
lcd.drawLine(93,25,93,36, SOLID, FORCE)
lcd.drawLine(93,38,93,63, SOLID, FORCE)
lcd.drawLine(94,21,94,22, SOLID, FORCE)
lcd.drawLine(94,28,94,33, SOLID, FORCE)
lcd.drawLine(94,39,94,63, SOLID, FORCE)
lcd.drawLine(95,21,95,22, SOLID, FORCE)
lcd.drawLine(95,28,95,33, SOLID, FORCE)
lcd.drawLine(95,39,95,63, SOLID, FORCE)
lcd.drawLine(96,21,96,23, SOLID, FORCE)
lcd.drawLine(96,25,96,36, SOLID, FORCE)
lcd.drawLine(96,38,96,63, SOLID, FORCE)
lcd.drawLine(119,23,119,28, SOLID, FORCE)
lcd.drawLine(119,33,119,37, SOLID, FORCE)
lcd.drawLine(122,23,122,28, SOLID, FORCE)
lcd.drawLine(123,33,123,37, SOLID, FORCE)
 
  
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