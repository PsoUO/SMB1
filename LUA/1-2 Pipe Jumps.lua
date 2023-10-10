local ram_Player_X_Speed        = 0x57
local ram_Player_Rel_XPos       = 0x3AD
-- 0 standing, 1 airborn by jumping, 2 airborn by walking off edge, 3 sliding down flagpole
local ram_Player_Float_State    = 0x01D
local ram_Player_X_Page         = 0x06D
local ram_Player_X_Pixel        = 0x086
local ram_Player_Y_Pixel        = 0x0CE
-- 8 normal, 6 dies (one frame after anim), 11 dying
local ram_Player_State          = 0x00E
-- 
local ram_AB_Button_State       = 0x000A

local text_colour            = "white"
local text_faded_colour      = "#FFFFFF80"
local text_back_colour       = "#00000066"

frame = 0
firstJumpFrame = 0
frameCount = 0
firstJumpPixel = 0


function display()

	-- 0 standing, 1 airborn by jumping, 2 airborn by walking off edge, 3 sliding down flagpole
	floatState = emu.read(ram_Player_Float_State, 7, 0)
	playerXPage = emu.read(ram_Player_X_Page, 7, 0)
	--playerXPixel = formatXPixel(emu.read(ram_Player_X_Pixel, 7, 1))
	playerXPixel = emu.read(ram_Player_X_Pixel, 7, 0)
	-- 0 no buttons, 128 jump(A) only, 64 run(B) only, 192 both
	abButtonState = emu.read(ram_AB_Button_State, 7, 0)
	-- 8 normal, 6 dies (one frame after anim), 11 dying
	playerState = emu.read(ram_Player_State, 7, 0)
	
	state = emu.getState()
	
	
	
	-- clears values
	if playerXPage < 5 or ( playerXPage == 5 and playerXPixel <= 150 ) then
		emu.log("cleared")  
		frameCount = 0
		firstJumpFrame = 0
		firstJumpPixel = 0
	
	end
	
	-- record inputs
	if playerXPage == 5 or playerXPage == 6 then
	
		if abButtonState == 192 then -- A + B pressed
		--emu.log("itdo " .. frameCount)
			if frameCount == 0 then
				frameCount = state["frameCount"] 
				firstJumpFrame = state["frameCount"]
				firstJumpPixel = playerXPixel
			end
		end
		
		if firstJumpPixel == 246 then
			emu.drawString(11, 170, "First Frame", 0xFFFFFF, 0xFF000000)
		elseif firstJumpPixel == 249 then
			emu.drawString(11, 170, "Second Frame", 0xFFFFFF, 0xFF000000)
		elseif firstJumpPixel == 244 then
			emu.drawString(11, 170, "One Frame Early -1", 0xFFFFFF, 0xFF000000)
		elseif firstJumpPixel == 241 then
			emu.drawString(11, 170, "Two Frames Early -2", 0xFFFFFF, 0xFF000000)
		elseif firstJumpPixel == 239 then
			emu.drawString(11, 170, "Three Frames Early -3", 0xFFFFFF, 0xFF000000)
		elseif firstJumpPixel == 236 then
			emu.drawString(11, 170, "Four Frames Early -4", 0xFFFFFF, 0xFF000000)
		elseif firstJumpPixel == 234 then
			emu.drawString(11, 170, "Five Frames Early -5", 0xFFFFFF, 0xFF000000)
		elseif firstJumpPixel == 251 then
			emu.drawString(11, 170, "One Frame Late +1", 0xFFFFFF, 0xFF000000)
		elseif firstJumpPixel == 254 then
			emu.drawString(11, 170, "Two Frames Late +2", 0xFFFFFF, 0xFF000000)
		end
		
	end

end







emu.addEventCallback(display, emu.eventType.endFrame);