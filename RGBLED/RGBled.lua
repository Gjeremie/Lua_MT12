local function init()
end

local blink = 0 -- clignot
local R -- valeur rouge
local sa -- switch sa
local link -- qualité signal



local function run()

link = getValue('RQly') -- qualité signal
sa = getValue('sa')  -- valeur  switch sa


  -- ================ LED haute =================
  
if (link<50 or link == nil ) then
  
		if (getTime()> (40+ blink) ) then -- attente  x 10ms = 500 ms
		
		R = (getTime() - blink-40) /(170-40) *255
		if R>255 then
		R = 255
		end
		
		
			for i=0, 2, 1 -- led haute
			do
			setRGBLedColor(i, R, 0, 0) -- rouge
			end
		end
		if (getTime()> (170+ blink) ) then -- attente  x 10ms = 1000 ms avant de reinitialiser
			for i=0, 2, 1 -- led haute
			do
			setRGBLedColor(i, 0, 0, 0) -- etein
			end
		blink =  getTime()
		end
	  
	else

		for i=0, 2, 1 -- led haute
		  do
			setRGBLedColor(i, 0, 255, 0) -- vert
		  end
	  
end
  
  
  
    -- ================ LED base =================
  
  
  
 if sa> 500 then
  
	  for i=3, 6, 1 -- led base
			  do
				setRGBLedColor(i, 255, 128, 0) -- orange
			  end
elseif sa< -500 then
	  for i=3, 6, 1 -- led base
			  do
				setRGBLedColor(i, 0, 255, 255) -- cyan
			  end

else
			  for i=3, 6, 1 -- led base
			  do
				setRGBLedColor(i, 0, 255, 0) -- vert
			  end	  
end	  
  
  
  
  
  
  
  -- ================ applique couleur ==========
applyRGBLedColors()
      
end
local function background()
end
return { run=run, background=background, init=init }