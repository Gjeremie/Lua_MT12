local shared = ...    -- varaiabe partage entre ecran

-------------- VARIABLES ------------------------


local blink1 = 0 -- variable stockage temps pour clignotement
local blink2 = 0 -- variable stockage temps pour clignotement
local blink3 = 0 -- variable stockage temps pour clignotement
local blink4 = 0 -- variable stockage temps pour clignotement

local modif = 0 -- modif start timer 2
local start = 0 -- modif start timer 2
local rebound = 0 -- anti rebond Enter key
local pag = 1 -- page telem
local horl = 0

local FMode = 0  -- mode de vol
local FModeName = {}      -- table nom MODE DE VOL :  largeur max 6 carac
FModeName[0]=model.getFlightMode(0).name-- "Normal"                
  FModeName[1]=model.getFlightMode(1).name-- "Astro"
  FModeName[2]=model.getFlightMode(2).name-- "Grip"
  FModeName[3]=model.getFlightMode(3).name-- "Terre"
  FModeName[4]=model.getFlightMode(4).name-- "Glisse"
  FModeName[5]=model.getFlightMode(5).name-- "Humide"

local TxV -- tension tx         en volt
local Thr -- valeur  channel 2 (throttle)       de -1024 a 1024
local St -- valeur  channel 1 (steering)       de -1024 a 1024


local gaz --  pour donne brute gaz
local vol --  pour donne brute volant

local TrimSt -- valeur trim steering de de -4194 a 4194


local sa --  valeur  switch sa   de -1024 a 1024 et 0 en pos centrale


local G2 --  valeur  g2 vitesse gaz  de 0 a 100
local G6 --  valeur  g6 force ABS
local G7 --  valeur  g7 force drag brake
local G8 --  valeur  g8 force SA

local val -- valeur temp
local saval -- valeur switch sa input
local fan --  pour ventilo

local vls58 -- valeur alerte tension TX - ls58

local ls26 -- etat frein ou pas - ls26


local link1 -- qualité signal
local link2 -- qualité signal

local capa  -- en mA/h - variable capacité calculé  
local tempM  -- en °C - variable temperature MAX calculé
local voltM  -- en mv - variable tension lipo MIN calculé  (utiliser getvalue avec  RXBt-  )

local temp  -- en °C - variable temperature live
local volt  -- en mv - variable tension lipo live
local voltaff = 0  
local courant  -- en ma - variable courant live

local tempON  -- true si telem transmise 
local voltON  -- true si telem transmise 
local courantON  -- true si telem transmise 
local courantM
local rpm
local rpmON

local function jaugelive(x,y,live)  -- x>200= affiche echelle

if live <-1024 then
live = -1024
end
if live >1024 then
live = 1024
end

if x>200 then
lcd.drawLine(67+16,y-2,111+16,y-2, SOLID, FORCE)
lcd.drawLine(67+16,y-1,68+16,y-1, SOLID, FORCE)
lcd.drawPoint(75+16,y-1)
lcd.drawPoint(82+16,y-1)
lcd.drawPoint(89+16,y-1)
lcd.drawPoint(96+16,y-1)
lcd.drawPoint(103+16,y-1)
lcd.drawLine(110+16,y-1,111+16,y-1, SOLID, FORCE)

x=x-200

end


if (live > 50) then
	lcd.drawLine(x, y, x + math.floor(live*22/1024), y, SOLID, FORCE)   -- jauge de 22 pixel avec max steering  de 1024 et debut a
	
else	
	if (live < -50) then
		lcd.drawLine(x- math.floor(-live*22/1024), y,  x , y, SOLID, FORCE)   -- jauge de 22 pixel avec min steering  de - 1024
	else
		lcd.drawPoint(x,y) -- dessin ligne centrale
	end
end


end

 
local function sadiff(a,b,z)   -- z:  1= sadiff    10= sadiff2  3= sadiff3

local inv = 0
if getValue('ls9') > 0 then -- ecart reglage sa
inv = 0+INVERS
end

	if sa ~= 0 then

		if z == 1 or z == 10 then


		if math.floor((a * b /100 - a)*z+0.5)/z > 0 then
		
			lcd.drawText(55, 9, "+" .. math.floor(math.floor((a * b /100 - a)*z+0.5)/z) ,  inv) -- valeur avec sa  corrigé
		
		
		else
			if math.floor((a * b /100 - a)*z+0.5)/z < 0 then
			
			lcd.drawText(56, 9, math.floor(math.floor((a * b /100 - a)*z+0.5)/z) ,  inv) -- valeur avec sa  corrigé
			
				
			else
			
			lcd.drawNumber(62, 9, 0 ,  inv) -- valeur 0
			
		
		
			end
		end

				
		elseif z == 3 then
		if (b-a) > 0 then
		
			lcd.drawText(55, 9, "+" .. (b-a) ,  inv) -- valeur avec sa  corrigé
		
		else
			if (b-a) < 0 then
			
			lcd.drawText(56, 9, (b-a) ,  inv) -- valeur avec sa  corrigé
	
			else
			
			lcd.drawNumber(62, 9, 0 ,  inv) -- valeur 0
		
			end
		end
		end
	end
end



local function mod(x,y,val,z) -- z:  99= dualrate0  9= mod1



	if (val>z) then
			-- dessin 100 pourcent
					
			lcd.drawPoint(0+x,1+y) -- 10
			lcd.drawRectangle(x+1, y, 2, 10, SOLID)
			lcd.drawFilledRectangle(x+4, y, 5, 10, SOLID)
			lcd.drawLine(x+6,y+1,x+6,y+8, SOLID, ERASE) 
			
			if z >9 then
			lcd.drawFilledRectangle(x+10, y, 5, 10, SOLID) -- 0 en pluss
			lcd.drawLine(x+12,y+1,x+12,y+8, SOLID, ERASE) 
			end
			
		else
		lcd.drawNumber(x+1, y-1, val , MIDSIZE) -- valeur DR  
	end

		
end



local function drawicon(x,y,z) -- 0= th   1=st    2= br   3 = D   4 = M  5 = eclair  6 = C  7 = thermo  8 = timer 9 = chrono  10= ventil   11 =  fleche 12 = compteur vitesse  13 = icone abs  14 = icone dr Brake   15 = Abs    16= drg  17 = icone etage frein  18 = icone drag

if z == 0 then
	lcd.drawLine(0+x,0+y,2+x,0+y, SOLID, FORCE)
lcd.drawLine(5+x,3+y,6+x,3+y, SOLID, FORCE)
lcd.drawLine(1+x,1+y,1+x,6+y, SOLID, FORCE)
lcd.drawLine(4+x,0+y,4+x,6+y, SOLID, FORCE)
lcd.drawLine(7+x,0+y,7+x,6+y, SOLID, FORCE)
end

if z == 1 then
lcd.drawLine(1+x,0+y,2+x,0+y, SOLID, FORCE)
lcd.drawLine(5+x,0+y,7+x,0+y, SOLID, FORCE)
lcd.drawPoint(3+x,1+y)
lcd.drawLine(1+x,3+y,2+x,3+y, SOLID, FORCE)
lcd.drawPoint(0+x,5+y)
lcd.drawLine(1+x,6+y,2+x,6+y, SOLID, FORCE)
lcd.drawLine(0+x,1+y,0+x,2+y, SOLID, FORCE)
lcd.drawLine(3+x,4+y,3+x,5+y, SOLID, FORCE)
lcd.drawLine(6+x,1+y,6+x,6+y, SOLID, FORCE)

end

if z == 2 then
lcd.drawLine(0+x,0+y,2+x,0+y, SOLID, FORCE)
lcd.drawLine(5+x,0+y,7+x,0+y, SOLID, FORCE)
lcd.drawLine(1+x,3+y,2+x,3+y, SOLID, FORCE)
lcd.drawLine(6+x,3+y,7+x,3+y, SOLID, FORCE)
lcd.drawPoint(7+x,4+y)
lcd.drawLine(0+x,6+y,2+x,6+y, SOLID, FORCE)
lcd.drawLine(0+x,1+y,0+x,5+y, SOLID, FORCE)
lcd.drawLine(3+x,1+y,3+x,2+y, SOLID, FORCE)
lcd.drawLine(3+x,4+y,3+x,5+y, SOLID, FORCE)
lcd.drawLine(5+x,1+y,5+x,6+y, SOLID, FORCE)
lcd.drawLine(8+x,1+y,8+x,2+y, SOLID, FORCE)
lcd.drawLine(8+x,5+y,8+x,6+y, SOLID, FORCE)
end

if z == 3 then
lcd.drawFilledRectangle(x, y, 6, 11, FORCE)
lcd.drawLine(1+x,1+y,1+x,9+y, SOLID, ERASE)
lcd.drawLine(4+x,4+y,4+x,6+y, SOLID, ERASE)
lcd.drawLine(x+2,y+1,x+4,y+3, SOLID, ERASE)
lcd.drawLine(x+2,y+9,x+4,y+7, SOLID, ERASE)
end

if z == 4 then
lcd.drawFilledRectangle(x, y, 7, 11, FORCE)
lcd.drawLine(x+1,y+1,x+3,y+3, SOLID, ERASE)
lcd.drawLine(x+4,y+2,x+5,y+1, SOLID, ERASE)
lcd.drawLine(1+x,2+y,1+x,9+y, SOLID, ERASE)
lcd.drawLine(5+x,2+y,5+x,9+y, SOLID, ERASE)

end

if z == 5 then
lcd.drawPoint(x+3,y+0)
lcd.drawPoint(x+2,y+1)
lcd.drawLine(x+1,y+2,x+2,y+2, SOLID, FORCE)
lcd.drawLine(x+0,y+3,x+1,y+3, SOLID, FORCE)
lcd.drawLine(x+0,y+4,x+3,y+4, SOLID, FORCE)
lcd.drawLine(x+2,y+5,x+3,y+5, SOLID, FORCE)
lcd.drawLine(x+1,y+6,x+2,y+6, SOLID, FORCE)
lcd.drawPoint(x+1,y+7)
lcd.drawPoint(x+0,y+8)
end

if z == 6 then
lcd.drawLine(x+2,y+0,x+4,y+0, SOLID, FORCE)
lcd.drawPoint(x+1,y+1)
lcd.drawPoint(x+5,y+1)
lcd.drawPoint(x+1,y+7)
lcd.drawPoint(x+5,y+7)
lcd.drawLine(x+2,y+8,x+4,y+8, SOLID, FORCE)
lcd.drawLine(x+0,y+2,x+0,y+6, SOLID, FORCE)
lcd.drawLine(x+1,y+2,x+1,y+6, SOLID, FORCE)
end

if z == 7 then
lcd.drawLine(x+2,y+0,x+3,y+0, SOLID, FORCE)
lcd.drawPoint(x+3,y+2)
lcd.drawPoint(x+3,y+4)
lcd.drawPoint(x+1,y+8)
lcd.drawPoint(x+4,y+8)
lcd.drawLine(x+2,y+9,x+3,y+9, SOLID, FORCE)
lcd.drawLine(x+0,y+6,x+0,y+7, SOLID, FORCE)
lcd.drawLine(x+1,y+1,x+1,y+5, SOLID, FORCE)
lcd.drawLine(x+4,y+1,x+4,y+5, SOLID, FORCE)
lcd.drawLine(x+5,y+6,x+5,y+7, SOLID, FORCE)
end

if z == 8 or z ==9 then
lcd.drawLine(x+3,y+1,x+5,y+1, SOLID, FORCE)
lcd.drawLine(x+1,y+2,x+2,y+2, SOLID, FORCE)
lcd.drawLine(x+6,y+2,x+7,y+2, SOLID, FORCE)
lcd.drawPoint(x+1,y+3)
lcd.drawPoint(x+7,y+3)
lcd.drawPoint(x+3,y+5)
lcd.drawPoint(x+1,y+7)
lcd.drawPoint(x+7,y+7)
lcd.drawLine(x+1,y+8,x+2,y+8, SOLID, FORCE)
lcd.drawLine(x+6,y+8,x+7,y+8, SOLID, FORCE)
lcd.drawLine(x+3,y+9,x+5,y+9, SOLID, FORCE)
lcd.drawLine(x+0,y+4,x+0,y+6, SOLID, FORCE)
lcd.drawLine(x+4,y+3,x+4,y+5, SOLID, FORCE)
lcd.drawLine(x+8,y+4,x+8,y+6, SOLID, FORCE)
lcd.drawLine(103,56,103,57, SOLID, FORCE)
lcd.drawLine(103,60,103,61, SOLID, FORCE)
lcd.drawText(82, 58, z-7 , SMLSIZE)

end

if z == 9 then
lcd.drawLine(x+1,y+0,x+2,y+0, SOLID, FORCE)
lcd.drawLine(x+6,y+0,x+7,y+0, SOLID, FORCE)
lcd.drawLine(x+1,y+1,x+2,y+1, SOLID, FORCE)
lcd.drawLine(x+6,y+1,x+7,y+1, SOLID, FORCE)
end

if z == 10 then
lcd.drawLine(x+4,y+0,x+5,y+0, SOLID, FORCE)
lcd.drawPoint(x+4,y+1)
lcd.drawPoint(x+0,y+3)
lcd.drawLine(x+5,y+3,x+8,y+3, SOLID, FORCE)
lcd.drawLine(x+0,y+4,x+1,y+4, SOLID, FORCE)
lcd.drawPoint(x+4,y+4)
lcd.drawLine(x+7,y+4,x+8,y+4, SOLID, FORCE)
lcd.drawLine(x+0,y+5,x+3,y+5, SOLID, FORCE)
lcd.drawPoint(x+8,y+5)
lcd.drawPoint(x+4,y+7)
lcd.drawLine(x+3,y+8,x+4,y+8, SOLID, FORCE)
lcd.drawLine(x+3,y+0,x+3,y+3, SOLID, FORCE)
lcd.drawLine(x+5,y+5,x+5,y+8, SOLID, FORCE)
end

if z == 11 then
lcd.drawPoint(x,y) -- dessin point fleche
	lcd.drawLine(x-1, y+1, x+1, y+1, SOLID, FORCE) -- dessin ligne fleche
		lcd.drawLine(x-2, y+2, x+2, y+2, SOLID, FORCE) -- dessin ligne fleche
end
if z == 12 then
lcd.drawLine(4+x,0+y,7+x,0+y, SOLID, FORCE)
lcd.drawLine(2+x,1+y,3+x,1+y, SOLID, FORCE)
lcd.drawPoint(5+x,1+y)
lcd.drawLine(8+x,1+y,9+x,1+y, SOLID, FORCE)
lcd.drawPoint(2+x,2+y)
lcd.drawPoint(8+x,2+y)
lcd.drawPoint(3+x,3+y)
lcd.drawPoint(4+x,4+y)
lcd.drawPoint(1+x,5+y)
lcd.drawLine(5+x,5+y,6+x,5+y, SOLID, FORCE)
lcd.drawPoint(10+x,5+y)
lcd.drawLine(5+x,6+y,6+x,6+y, SOLID, FORCE)
lcd.drawLine(1+x,8+y,10+x,8+y, SOLID, FORCE)
lcd.drawLine(0+x,4+y,0+x,7+y, SOLID, FORCE)
lcd.drawLine(1+x,2+y,1+x,3+y, SOLID, FORCE)
lcd.drawLine(10+x,2+y,10+x,3+y, SOLID, FORCE)
lcd.drawLine(11+x,4+y,11+x,7+y, SOLID, FORCE)

end

if z == 13 then
lcd.drawLine(1+x,y,2+x,y, SOLID, FORCE)
lcd.drawPoint(x,y+1)
lcd.drawPoint(x+3,y+1)
lcd.drawPoint(x,y+6)
lcd.drawPoint(x+3,y+6)
lcd.drawLine(x+1,y+7,x+2,y+7, SOLID, FORCE)
lcd.drawFilledRectangle(x, y+2, 4, 4, SOLID)
end

if z == 14 then
-- Dr brake 
lcd.drawLine(x,y,x,y+9, SOLID, FORCE)
lcd.drawLine(x+1,y+3,x+1,y+9, SOLID, FORCE)
lcd.drawLine(x+2,y+6,x+2,y+9, SOLID, FORCE)
lcd.drawLine(x+3,y+8,x+3,y+9, SOLID, FORCE)
lcd.drawPoint(x+4,y+9)
end

if z == 15 then
-- abs
lcd.drawLine(1+x,0+y,2+x,0+y, SOLID, FORCE)
lcd.drawLine(5+x,0+y,7+x,0+y, SOLID, FORCE)
lcd.drawLine(11+x,0+y,12+x,0+y, SOLID, FORCE)
lcd.drawPoint(13+x,1+y)
lcd.drawLine(1+x,3+y,2+x,3+y, SOLID, FORCE)
lcd.drawLine(6+x,3+y,7+x,3+y, SOLID, FORCE)
lcd.drawLine(11+x,3+y,12+x,3+y, SOLID, FORCE)
lcd.drawPoint(10+x,5+y)
lcd.drawLine(5+x,6+y,7+x,6+y, SOLID, FORCE)
lcd.drawLine(11+x,6+y,12+x,6+y, SOLID, FORCE)
lcd.drawLine(0+x,1+y,0+x,6+y, SOLID, FORCE)
lcd.drawLine(3+x,1+y,3+x,6+y, SOLID, FORCE)
lcd.drawLine(5+x,1+y,5+x,5+y, SOLID, FORCE)
lcd.drawLine(8+x,1+y,8+x,2+y, SOLID, FORCE)
lcd.drawLine(8+x,4+y,8+x,5+y, SOLID, FORCE)
lcd.drawLine(10+x,1+y,10+x,2+y, SOLID, FORCE)
lcd.drawLine(13+x,4+y,13+x,5+y, SOLID, FORCE)
end

if z == 16 then
-- drg
lcd.drawLine(1+x,0+y,2+x,0+y, SOLID, FORCE)
lcd.drawLine(6+x,0+y,7+x,0+y, SOLID, FORCE)
lcd.drawLine(11+x,0+y,12+x,0+y, SOLID, FORCE)
lcd.drawPoint(13+x,1+y)
lcd.drawLine(6+x,3+y,7+x,3+y, SOLID, FORCE)
lcd.drawPoint(7+x,4+y)
lcd.drawLine(12+x,4+y,13+x,4+y, SOLID, FORCE)
lcd.drawPoint(13+x,5+y)
lcd.drawLine(1+x,6+y,2+x,6+y, SOLID, FORCE)
lcd.drawLine(11+x,6+y,12+x,6+y, SOLID, FORCE)
lcd.drawLine(0+x,0+y,0+x,6+y, SOLID, FORCE)
lcd.drawLine(3+x,1+y,3+x,5+y, SOLID, FORCE)
lcd.drawLine(5+x,0+y,5+x,6+y, SOLID, FORCE)
lcd.drawLine(8+x,1+y,8+x,2+y, SOLID, FORCE)
lcd.drawLine(8+x,5+y,8+x,6+y, SOLID, FORCE)
lcd.drawLine(10+x,1+y,10+x,5+y, SOLID, FORCE)
end

if z == 17 then
-- icone etage frein
lcd.drawLine(10+x,0+y,12+x,0+y, SOLID, FORCE)
lcd.drawPoint(9+x,1+y)
lcd.drawLine(4+x,2+y,8+x,2+y, SOLID, FORCE)
lcd.drawPoint(6+x,5+y)
lcd.drawPoint(9+x,5+y)
lcd.drawLine(5+x,6+y,6+x,6+y, SOLID, FORCE)
lcd.drawLine(9+x,6+y,10+x,6+y, SOLID, FORCE)
lcd.drawPoint(2+x,9+y)
lcd.drawLine(0+x,10+y,1+x,10+y, SOLID, FORCE)
lcd.drawLine(3+x,3+y,3+x,8+y, SOLID, FORCE)
lcd.drawLine(7+x,4+y,7+x,9+y, SOLID, FORCE)
lcd.drawLine(8+x,4+y,8+x,9+y, SOLID, FORCE)
end

if z == 18 then
-- icone drag
lcd.drawPoint(3+x,0+y)
lcd.drawPoint(2+x,1+y)
lcd.drawPoint(2+x,6+y)
lcd.drawPoint(3+x,7+y)
lcd.drawLine(0+x,3+y,0+x,4+y, SOLID, FORCE)
lcd.drawLine(1+x,3+y,1+x,4+y, SOLID, FORCE)
end

end


function shared.run(event)  -- BOUCLE PRINCIPALE -- DEBUT  ---------------------- run is called periodically only when screen is visible


---- touche bascule entre ecran -----------------
 if event == EVT_VIRTUAL_MENU then -- bouton menu 
  playTone(1200, 120,5) -- play tone
    shared.changeScreen(3)
  end
  
 if event == EVT_VIRTUAL_MENU_LONG then -- bouton menu 
  playTone(1200, 120,5) -- play tone
    shared.changeScreen(5)
  end


------ affectation valeur ----------


TxV = getValue('tx-voltage')  -- tension tx
Thr = getValue('ch2')  -- valeur  channel 2 (throttle) 
St = getValue('ch1')  -- valeur  channel 1 (steering) 
gaz = getValue('ch7') -- valeur channel 7 gaz brute
vol = getValue('ch6') -- valeur channel 6 volant brute

sa = getValue('sa')  -- valeur  switch sa

G2 = getValue('gvar2')/1.024  -- valeur  g2 de 0 a 1000
G6 = getValue('gvar6')  -- valeur  g6 de 0 a 100
G7 = getValue('gvar7')  -- valeur  g7 de -100 a 100
G8 = getValue('gvar8')  -- valeur  g8 de 0 a 150
TrimSt = getValue('gvar5') -- valeur subtrim steering de -80 a 80 par pas de 1 (GVAR5)


saval = getValue('input12')/10.24  -- valeur  input 12 de switch SA en pourcentage
fan = model.getOutput(2).max/10  -- recup valeur output max de ch3 (2) (vitesse max ventilo) 0 a 100
vls58 = model.getLogicalSwitch(57).v2 -- valeur alerte tension TX - ls58

ls26 = getValue('ls26')-- etat frein ou pas - ls26

link1 = getValue('1RSS') -- qualité signal
link2 = getValue('2RSS') -- qualité signal

capa = getSourceValue('Capa') -- en mA/h - variable capacité calculé
tempM = getSourceValue('Temp+') -- en °C - variable temperature MAX calculé
voltM = getSourceValue('Lipo-') -- en mv - variable tension lipo MIN calculé  (utiliser getvalue avec  RXBt-  )

-- la deusieme variable (exemple :tempON) contient true ou false en fcontion de si la telemetrei est transmise ou non
temp, tempON = getSourceValue('Temp') -- en °C - variable temperature live
courant, courantON  = getSourceValue('Curr') -- en ma - variable courant live
volt, voltON = getSourceValue('Lipo') -- en mv - variable tension lipo live

courantM  = getSourceValue('Curr+') -- en ma - variable courant maximum

rpm, rpmON = getSourceValue('Rpm') -- var altitude fake tranmission vitesse


-------------- AFFICHAGE sur LCD : -------------------------
lcd.clear()

----  DESSIN FOND ------ DEBUT -- 

-- fond noir

lcd.drawFilledRectangle(0, 0, 54, 17, FORCE)

-- Erase carré manuel:
lcd.drawRectangle(10, 2, 5, 2, ERASE)
lcd.drawRectangle(23, 14, 5, 2, ERASE)
lcd.drawRectangle(25, 9, 4, 2, ERASE)
lcd.drawRectangle(8, 14, 2, 2, ERASE)
lcd.drawRectangle(11, 13, 2, 3, ERASE)
lcd.drawRectangle(14, 11, 2, 5, ERASE)
lcd.drawRectangle(17, 9, 2, 7, ERASE)

lcd.drawLine(2,13,3,12, SOLID, ERASE)
lcd.drawLine(4,12,5,13, SOLID, ERASE)
lcd.drawLine(25,11,26,12, SOLID, ERASE)

lcd.drawLine(13,1,14,1, SOLID, ERASE)
lcd.drawLine(11,5,13,5, SOLID, ERASE)
lcd.drawLine(11,7,13,7, SOLID, ERASE)
lcd.drawLine(2,10,5,10, SOLID, ERASE)
lcd.drawPoint(31,10)
lcd.drawPoint(51,10)
lcd.drawPoint(1,11)
lcd.drawPoint(6,11)
lcd.drawPoint(23,11)
lcd.drawPoint(27,11)
lcd.drawLine(3,15,4,15, SOLID, ERASE)
lcd.drawPoint(31,15)
lcd.drawPoint(51,15)
lcd.drawLine(1,3,1,5, SOLID, ERASE)
lcd.drawLine(2,2,2,6, SOLID, ERASE)
lcd.drawLine(3,1,3,7, SOLID, ERASE)
lcd.drawLine(10,4,10,7, SOLID, ERASE)
lcd.drawLine(14,4,14,7, SOLID, ERASE)
lcd.drawLine(24,10,24,13, SOLID, ERASE)
lcd.drawLine(52,12,52,13, SOLID, ERASE)



-- carré manuel
lcd.drawFilledRectangle(31, 10, 21, 6, ERASE)


lcd.drawRectangle(25, 21, 2, 7, SOLID)
lcd.drawRectangle(29, 33, 2, 4, SOLID)
lcd.drawFilledRectangle(32, 33, 3, 4, FORCE)
lcd.drawLine(104,19,109,19, SOLID, FORCE)
lcd.drawLine(106,22,107,22, SOLID, FORCE)
lcd.drawLine(105,23,108,23, SOLID, FORCE)
lcd.drawLine(103,24,105,24, SOLID, FORCE)
lcd.drawLine(108,24,110,24, SOLID, FORCE)
lcd.drawLine(103,25,104,25, SOLID, FORCE)
lcd.drawLine(109,25,110,25, SOLID, FORCE)
lcd.drawLine(104,26,105,26, SOLID, FORCE)
lcd.drawLine(108,26,109,26, SOLID, FORCE)
lcd.drawPoint(22,27)
lcd.drawLine(106,27,107,27, SOLID, FORCE)
lcd.drawPoint(114,36)
lcd.drawPoint(113,37)
lcd.drawLine(111,38,112,38, SOLID, FORCE)
lcd.drawLine(108,39,116,39, SOLID, FORCE)
lcd.drawLine(23,26,23,27, SOLID, FORCE)
lcd.drawLine(24,24,24,27, SOLID, FORCE)
lcd.drawLine(35,30,35,39, SOLID, FORCE)
lcd.drawLine(36,31,36,38, SOLID, FORCE)
lcd.drawLine(37,33,37,36, SOLID, FORCE)
lcd.drawLine(38,34,38,35, SOLID, FORCE)
lcd.drawLine(102,22,102,23, SOLID, FORCE)
lcd.drawLine(103,20,103,21, SOLID, FORCE)
lcd.drawLine(108,31,108,38, SOLID, FORCE)
lcd.drawLine(110,20,110,21, SOLID, FORCE)
lcd.drawLine(111,22,111,23, SOLID, FORCE)
lcd.drawLine(115,34,115,35, SOLID, FORCE)
lcd.drawLine(116,31,116,33, SOLID, FORCE)
lcd.drawFilledRectangle(6, 18, 5, 11, FORCE)
lcd.drawFilledRectangle(7, 30, 4, 11, FORCE)
lcd.drawFilledRectangle(0, 42, 8, 11, FORCE)
lcd.drawLine(7,19,8,19, SOLID, ERASE)
lcd.drawLine(7,23,8,23, SOLID, ERASE)
lcd.drawLine(8,31,9,31, SOLID, ERASE)
lcd.drawLine(8,39,9,39, SOLID, ERASE)
lcd.drawLine(1,43,3,43, SOLID, ERASE)
lcd.drawLine(5,51,7,51, SOLID, ERASE)
lcd.drawLine(2,44,2,51, SOLID, ERASE)
lcd.drawLine(5,43,5,50, SOLID, ERASE)
lcd.drawLine(6,19,6,27, SOLID, ERASE)
lcd.drawLine(7,32,7,38, SOLID, ERASE)
lcd.drawLine(8,24,8,25, SOLID, ERASE)
lcd.drawLine(9,20,9,22, SOLID, ERASE)
lcd.drawLine(9,26,9,27, SOLID, ERASE)
lcd.drawLine(10,32,10,38, SOLID, ERASE)

  
  -- cadre pour swith SA
 lcd.drawLine(116-57,0,125-57,0, SOLID, FORCE)
  lcd.drawLine(116-57,6,125-57,6, SOLID, FORCE)
  lcd.drawLine(115-57,1,115-57,5, SOLID, FORCE)
  lcd.drawLine(126-57,1,126-57,5, SOLID, FORCE)

lcd.drawFilledRectangle(15, 42, 3, 11, FORCE)

  lcd.drawLine(20,42,20,48, SOLID, FORCE) -- F
  lcd.drawLine(21,42,22,42, SOLID, FORCE) -- F
  lcd.drawPoint(21,45) -- F
	
lcd.drawText(24, 43, "AN" , SMLSIZE)

drawicon(74,0,0) -- th de jauge live

drawicon(13,18,0)
drawicon(19,30,0)

drawicon(74,9,1) -- st de jauge live

drawicon(93,18,1)
drawicon(98,30,1)

drawicon(0,18,3)
drawicon(11,30,3)

drawicon(0,30,4)
drawicon(8,42,4)

----  DESSIN FOND ------ FIN --

-- mode de vol --
	FMode = getFlightMode() -- recup flight mode actuel
	lcd.drawText(17, 1,FModeName[FMode], 0+INVERS) -- texte mode de vol
  

-- link --
	if ((link1 < -98 and link2 < -98) or link1 == nil  or link1 == 0 ) then 
		lcd.drawLine(8, 14, 9, 14, SOLID, FORCE) -- -- dessin puissance link  à 1	
	end
	if ((link1 < -88 and link2 < -88)  or link1 == nil or link1 == 0) then 
		lcd.drawRectangle(11, 13, 2, 2) -- -- dessin puissance link  à 2	
	end
	if ((link1 < -75 and link2 < -75)  or link1 == nil or link1 == 0) then 
		lcd.drawRectangle(14, 11, 2, 4) -- -- dessin puissance link  à 3	
	end
	if ((link1 < -50 and link2 < -50)  or link1 == nil or link1 == 0) then 
		lcd.drawRectangle(17, 9, 2, 6) -- -- dessin puissance link  à 4	
	end

	
-- Affichage mode volume ou Mute --

if (getValue('ls10') > 0) then --   ls volume ou mute

lcd.drawLine(5,4,7,6, SOLID, ERASE)
lcd.drawPoint(7,4)
lcd.drawPoint(5,6)



end
	
	
-- Jauge tension TX --

if (((TxV-vls58/10)*19/(8.4-vls58/10)) > 2) then
	lcd.drawRectangle(32, 11, math.floor((TxV-vls58/10)*19/(8.4-vls58/10)), 2)        -- Jauge tension Tx ( mini recup de LS 58 et 8.4 max) ) jauge de 19 case
	lcd.drawRectangle(32, 13,  math.floor((TxV-vls58/10)*19/(8.4-vls58/10)), 2)
else

	if getValue('ls58') >0 then -- si alerte tension
	
	if (getTime()> (50+ blink2) ) then -- attente 50 x 10ms = 500 ms
				lcd.drawRectangle(32, 11, 2, 4) -- affiche barre
			end
			if (getTime()> (100+ blink2) ) then -- attente 100 x 10ms = 1000 ms avant de reinitialiser
				blink2 =  getTime()
			end
	
	else
	lcd.drawRectangle(32, 11, 2, 4)
	end
end



-- SWITCH sa
	lcd.drawLine(118-57,2-sa/512,123-57,2-sa/512, SOLID, FORCE)
		lcd.drawLine(117-57,3-sa/512,124-57,3-sa/512, SOLID, FORCE)
		lcd.drawLine(118-57,4-sa/512,123-57,4-sa/512, SOLID, FORCE)




-- trim steering
if (TrimSt >0) then -- trim positif

	drawicon(89+math.floor((TrimSt*10+13)/13)+16,9+3,11)
		
	lcd.drawNumber(89+12+16, 9+2, math.abs(TrimSt*10) , SMLSIZE) -- valeur trim
	
else
if (TrimSt <0) then  -- trim negatif
	
	drawicon(89+math.ceil((TrimSt*10-13)/13)+16,9+3,11)
				
	lcd.drawNumber(89-20+16, 9+2, math.abs(TrimSt*10) , SMLSIZE) -- valeur trim

else -- trim central
	drawicon(89+16,9+3,11)
		
end
end


-- Affiche horloge heure actuelle --

 if math.floor(getValue('input28')) ~= math.floor(getValue('input29')) then -- verif si volant et gaz pas au milieu
 horl= getTime()

 end



if getTime() > horl +500  then -- verif si volant et gaz pas touché depuis 5 sec
 lcd.drawText(92, 1, getDateTime().hour .. ":" .. getDateTime().min .. ":" .. getDateTime().sec .. "        "  , 0+INVERS)

 
  lcd.drawLine(83,0,89,0, SOLID, FORCE)
     lcd.drawLine(83,1,84,1, SOLID, FORCE)
    
   lcd.drawLine(83,6,89,6, SOLID, FORCE)
   lcd.drawLine(83,7,84,7, SOLID, FORCE)
 
 lcd.drawPoint(89+16,10)
 
 
 
 else
 
 -- Valeur live throttle --
 jaugelive(305,2,Thr)
 jaugelive(105,3,Thr)
 jaugelive(105,4,gaz)


-- Valeur live steering --
jaugelive(305,8,St)
jaugelive(105,9,St)
jaugelive(105,10,vol)
 
end


-- Dual rate  throttle --
val = math.floor(getValue('input5')/10.24)  -- valeur  Dualrate throttle  remis a 100

if getValue('ls44') > 0 then -- si mode bouton limiteur dr th
-- avec bouton limiteur DR Th
lcd.drawLine(23,20,31,20, SOLID, FORCE)
lcd.drawLine(29,22,30,22, SOLID, FORCE)
lcd.drawLine(28,23,31,23, SOLID, FORCE)
lcd.drawLine(29,24,29,27, SOLID, FORCE)
lcd.drawLine(30,24,30,27, SOLID, FORCE)
else
-- sans bouton reglage DR th
lcd.drawLine(26,18,26,20, SOLID, FORCE)
end



if (getValue('ls50')>0) then -- valeur ls choix fonction SA1
sadiff (val,saval,1)
val = math.floor(val * saval /100+0.5)
lcd.drawLine(13,26,13+7,26, SOLID, FORCE)
end



if model.getOutput(1).max == 1000 then --si PAS mode enfant
mod(34,18,val,99)
else
lcd.drawText(34, 21,"KID", 0) -- texte mode enfant
end


-- Dual rate  brake --
if ls26>0 then -- si on freine
val = math.abs(G6-100)
	drawicon(53,18,15) -- abs
	
else -- si pas frein
drawicon(53,18,2) -- br
drawicon(64,18,14) -- br icon
val = getValue('gvar1') -- dr frein de 0 a 100

	if (getValue('ls51')>0) then -- valeur ls choix focntion sa2
	sadiff (val,saval,1)

	val = math.floor(val * saval /100+0.5)
	lcd.drawLine(53,26,53+8,26, SOLID, FORCE)
	end

	
end

mod(69,18,val,99) -- affiche valeur frein ou Abs

	-- affiche icone ABS :
	
if G6 <100 then
	
	if ls26>0 then -- si on freine
			
			if getValue('ch8') ~= 0 then -- si abs en marche
					if (getTime()> (25+ blink3) ) then -- attente 30 x 10ms = 350 ms
						drawicon(85,19,13) -- affiche icone abs
					end
					if (getTime()> (50+ blink3) ) then -- attente 55 x 10ms = 600 ms avant de reinitialiser
						blink3 =  getTime()
					end
			end		
					
	else -- si pas frein
	drawicon(85,19,13) -- affiche icone abs
	end
	
end



-- Dual rate  steering --
val = math.floor(getValue('input4')/10.24) -- dualrate steering remis a 100
if (getValue('ls52')>0) then -- ls choix fonction sa 3
sadiff (val,saval,1)

val = math.floor(val * saval /100+0.5)
lcd.drawLine(93,26,93+7,26, SOLID, FORCE)
end

mod(113,18,val,99)


-- vitesse gaz
val = math.floor(G2/100 +0.5)

if (getValue('ls53')>0) then -- si choix SA 4

		val = math.floor(G2/100+saval/10 +0.5)
		
		sadiff(math.floor(G2/100 +0.5),val,3)
		
		if val < 0 then
		val = 0
		end
		if val > 10 then
		val = 10
		end
		
	

	lcd.drawLine(19,38,19+7,38, SOLID, FORCE)
end

mod(41,30,val,9)


-- etage frein

if ls26>0 then -- si on freine

	val = G7 -- affiche valeur drag brake
	
	drawicon(55,30,16) -- texte drag brake

	if G7 ~= 4 then -- affiche icone drag brake si different de 4
	drawicon(88,31,18) -- icone drag brake
	else
	val = 0 -- affiche 0 si G7 = 4
	end
	
	
	
mod(71,30,val,99) --  affiche drag brake

else -- si on freine pas
	val = getValue('gvar3')/10  -- valeur  g3 de 0 a 10

	if (getValue('ls54')>0) then -- si choix sa 5
	sadiff(val,saval,10)

	val = math.floor(val * saval /100+0.5)
	lcd.drawLine(55,38,55+8,38, SOLID, FORCE) -- ligne selection MOD
	end
	
	if G7 ~= 4 then -- affiche icone drag brake si different de 4
	
	if getValue('ls43') > 0 and getValue('ch19') ~= 0  then -- ICI SI L43 > 0 (etat neutre)  AND ch19 ~= 0 THEN faire clignoter ELSE fixe
	    if (getTime()> (25+ blink4) ) then -- attente 30 x 10ms = 350 ms
						drawicon(88,31,18) -- affiche icone drag brake
					end
					if (getTime()> (50+ blink4) ) then -- attente 55 x 10ms = 600 ms avant de reinitialiser
						blink4 =  getTime()
					end
		else
		drawicon(88,31,18) -- affiche icone drag brake
	end
	
	end

drawicon(55,30,2) -- texte br
drawicon(63,30,17) -- icone etage frein
mod(78,30,val,9) -- afiche mod etage frein
end





-- expo steering
val = getValue('gvar4')/7 -- pour que valeur G4 0 a 70 apparaisse de 0 a 10

 
if (getValue('ls55')>0)  then -- si choix sa 6

			if  saval ~= 0	then
		sadiff(val,val-saval/math.abs(saval)*math.floor(G8/5+0.5)/10,3)
		
		val = val-saval/math.abs(saval)*math.floor(G8/50+0.5)
		
		if val < 0 then
		val = 0
		end
		if val > 10 then
		val = 10
		end
			end
lcd.drawLine(98,38,98+7,38, SOLID, FORCE)
end

mod(118,30,val,9)






-- Ventilateur
mod(45,42,math.floor(fan/10+0.5),9)  -- valeur fan  

if (getValue('ch3')> 5) and math.floor(fan/10+0.5) ~= 0 then -- si ventilo en marche recup valeur de channel 3

			if (getTime()> (50+ blink1) ) then -- attente 50 x 10ms = 500 ms
				drawicon(35,43,10) -- affiche icone
			end
			if (getTime()> (100+ blink1) ) then -- attente 100 x 10ms = 1000 ms avant de reinitialiser
				blink1 =  getTime()
			end
			
else
drawicon(35,43,10)

end


---- touche ROTARY -----------------
if modif == 1 then -- si en mode modif
-- bloque pag
	else
	if event == EVT_VIRTUAL_NEXT then -- bouton rotary 
		pag = pag-1
	if (pag <1) then
	pag =1
	else
	playTone(1200, 120,5) -- play tone
	end
	  end



	  
	if event == EVT_VIRTUAL_PREV then -- bouton rotary 
			pag = pag+1
	if (pag >3) then
	pag =3
	else
	playTone(1200, 120,5) -- play tone
	end
	  end
  
end






-------- ECRAN 1 TELEM   -------
if (pag == 1) then

lcd.drawRectangle(15, 49, 2, 3, ERASE)

lcd.drawPoint(108,48)
lcd.drawPoint(108,51)

lcd.drawFilledRectangle(0, 55, 5, 9, SOLID)
lcd.drawPoint(0,63)
lcd.drawPoint(4,63)
lcd.drawLine(2,58,3,58, SOLID, ERASE)
lcd.drawLine(2,62,3,62, SOLID, ERASE)
lcd.drawLine(1,59,1,61, SOLID, ERASE)





drawicon(58,43,5) -- 0= th   1=st    2= br   3 = d   4 = m  5 = eclair  6 = C  7 = thermo  8 = timer 9 = chrono
lcd.drawText(93, 45, "M" , 0)
lcd.drawText(99, 46, "IN" , SMLSIZE)
drawicon(39,54,7)
drawicon(72,54,8)



-- tps de roulage venant de timer 1
lcd.drawNumber(88, 53, math.floor(model.getTimer(0).value/60) , MIDSIZE ) -- minute tps ecoulé timer 1
lcd.drawNumber(106, 53, math.floor(math.fmod(model.getTimer(0).value,60)) , MIDSIZE ) -- seconde tps ecoulé timer 1


-- affiche tension LIPO Live
if volt == nil or voltON == false then
	-- affiche vide
	else
	
	if volt<4900 then
	voltaff = volt
	end
	
		if getValue('ls59') >0 then -- si alerte tension lipo clignote
		lcd.drawNumber(64, 41, math.floor(voltaff/100+0.5) , MIDSIZE+PREC1+BLINK) -- valeur tension lipo 3900mv format 39 V affiché 3.9 V
		else
		lcd.drawNumber(64, 41, math.floor(voltaff/100+0.5) , MIDSIZE+PREC1)
		end
	
	lcd.drawText(lcd.getLastRightPos(), 42, "V" , 0)
	
end  

-- affiche tension LIPO MINI
if voltM == nil then
	-- affiche vide
	else
	lcd.drawNumber(111, 41, math.floor(voltM/100+0.5) , MIDSIZE+PREC1) -- valeur tension MINI lipo 3900mv format 32 V affiché 3.2 V  
end



-- affiche capacité 
if capa == nil then
	-- affiche vide
	else
	lcd.drawNumber(7, 53, math.floor(capa/100+0.5) , MIDSIZE+PREC1) -- valeur courant   5230 mah format  affiché 5.23 Ah 
lcd.drawText(lcd.getLastRightPos(), 54, "A" , 0)
lcd.drawText(lcd.getLastRightPos(), 55, "H" , SMLSIZE)	
end


-- affiche temperature LIVE
if temp == nil or tempON == false then
	-- affiche vide
	else
	if getValue('ls60')>0 then -- si alerte temperature clignote
	lcd.drawNumber(47, 53, math.floor(temp+0.5) , MIDSIZE+BLINK) -- valeur    temperature 
	else
	lcd.drawNumber(47, 53, math.floor(temp+0.5) , MIDSIZE)
	end
	
lcd.drawPoint(lcd.getLastRightPos(),56)
lcd.drawPoint(lcd.getLastRightPos()+2,56)
lcd.drawLine(lcd.getLastRightPos(),55,lcd.getLastRightPos()+2,55, SOLID, FORCE)
lcd.drawLine(lcd.getLastRightPos(),57,lcd.getLastRightPos()+2,57, SOLID, FORCE)
end

end


-------- ECRAN 2 TELEM   -------
if (pag == 2) then

lcd.drawRectangle(15, 46, 2, 3, ERASE)

lcd.drawPoint(85,48)
lcd.drawPoint(85,51)


drawicon(59,42,7)  -- 0= th   1=st    2= br   3 = d   4 = m  5 = eclair  6 = C  7 = thermo  8 = timer 9 = chrono
lcd.drawText(69, 45, "M" , 0)
lcd.drawText(75, 46, "AX" , SMLSIZE)
drawicon(0,55,5)
drawicon(6,55,6)

drawicon(72,54,9)




-- affiche temperature MAX
if tempM == nil then
	-- affiche vide
	else
	lcd.drawNumber(89, 41, math.floor(tempM+0.5) , MIDSIZE) -- valeur    temperature 
	lcd.drawPoint(lcd.getLastRightPos(),44)
lcd.drawPoint(lcd.getLastRightPos()+2,44)
lcd.drawLine(lcd.getLastRightPos(),43,lcd.getLastRightPos()+2,43, SOLID, FORCE)
lcd.drawLine(lcd.getLastRightPos(),45,lcd.getLastRightPos()+2,45, SOLID, FORCE)
end


-- affiche courant LIVE
if courant == nil or courantON == false then
	-- affiche vide
	else
	lcd.drawNumber(15, 53, math.floor(courant/10+0.5) , MIDSIZE+PREC2) -- valeur courant   5120 ma format  affiché 5.12 A
lcd.drawText(lcd.getLastRightPos(), 54, "A" , 0)	
end


-- modif start timer 2
if modif == 0 then

-- tps venant de timer 2
lcd.drawNumber(88, 53, math.floor(model.getTimer(1).value/60) , MIDSIZE ) -- minute tps ecoulé timer 2
lcd.drawNumber(106, 53, math.floor(math.fmod(model.getTimer(1).value,60)) , MIDSIZE ) -- seconde tps ecoulé timer 2



	if ( event == EVT_VIRTUAL_ENTER and (getTime() - rebound) > 200 ) then -- bouton rotary ENTER
	playTone(1200, 120,5) -- play tone
		rebound = getTime()
	
		if model.getTimer(1).value == model.getTimer(1).start then
			start = model.getTimer(1).start
		   modif = 1
		end   
	   
	end
end


if modif == 1 then


-- tps venant de timer 2
lcd.drawNumber(88, 53, start/60 , MIDSIZE+INVERS ) -- minute tps ecoulé timer 2


---- touche ROTARY -----------------
if event == EVT_VIRTUAL_NEXT then -- bouton rotary 
    start = start+60
	if (start >1200) then
	start =1200
	else
	playTone(1200, 50,5) -- play tone
	end
  end

if event == EVT_VIRTUAL_PREV then -- bouton rotary 
    start = start-60
	if (start <60) then
	start =60
	else
	playTone(1200, 50,5) -- play tone
	end
  end


	if ( event == EVT_VIRTUAL_ENTER and (getTime() - rebound) > 200 ) then -- bouton rotary ENTER
	playTone(1200, 120,5) -- play tone
		rebound = getTime()
	
		local Ret = model.getTimer(1)
		Ret.start = start
		model.setTimer(1, Ret ) -- assigne valeur start de timer 2
		model.resetTimer(1)
		
	   modif = 0
	   
	   
	end
end

end


-------- ECRAN 3 TELEM   -------
if (pag == 3) then

lcd.drawRectangle(15, 43, 2, 3, ERASE)

lcd.drawPoint(85,48)
lcd.drawPoint(85,51)

drawicon(59,43,6)
lcd.drawText(69, 45, "M" , 0)
lcd.drawText(75, 46, "AX" , SMLSIZE)

-- icone RPM :
-- drawicon(0,55,12)


 -- affiche COURANT MAX
if courantM == nil then
	-- affiche vide
	else
	lcd.drawNumber(89, 41, math.floor(courantM/1000+0.5) , MIDSIZE) -- valeur    courant en A
	lcd.drawText(lcd.getLastRightPos(), 42, "A" , 0)
end


 -- affiche vitesse
-- if rpm == nil or rpmON == false then
	-- affiche vide
--	else
--	lcd.drawNumber(15, 53, math.floor(rpm/10+0.5) , MIDSIZE) -- valeur vitesse km/h
-- lcd.drawText(lcd.getLastRightPos(), 54, "K" , 0)
-- lcd.drawText(lcd.getLastRightPos(), 55, "M/H" , SMLSIZE)	
-- end

end


-- page:
lcd.drawNumber(123, 56,"1", 0+INVERS) -- texte numero page
	

if (shared.pop == 1 ) then -- si reset session

 popupWarning("Nouvelle Session", 0)

end





end ------------------ BOUCLE PRINCIPALE -- FIN -----

