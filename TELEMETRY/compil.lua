-- Main telemetry script


-- This is the manager script
-- Here will be the added variables
-- Screen Manager
local shared = { }   
shared.screens = {
"/SCRIPTS/TELEMETRY/0-M1S.lua",
  "/SCRIPTS/TELEMETRY/0-M1.lua",
  "/SCRIPTS/TELEMETRY/0-M2.lua",
  "/SCRIPTS/TELEMETRY/0-M3.lua",
  "/SCRIPTS/TELEMETRY/0-M4S.lua",
  "/SCRIPTS/TELEMETRY/0-M4.lua",
  "/SCRIPTS/TELEMETRY/0-M5.lua"
}



-- Screen Manager
function shared.changeScreen(ecran)
  shared.current =  ecran

  local chunk = loadScript(shared.screens[shared.current])
  chunk(shared)
end







local function init()



  shared.current = 2
  shared.changeScreen(2)
end



local function run(event)
  shared.run(event)
end



local function background()




	
	

	


	
end

return { run = run, init = init, background = background}