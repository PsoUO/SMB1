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
-- -112 falling, 40 not falling?
local ram_Player_Fall_Gravity   = 0x709

local text_colour            = "white"
local text_faded_colour      = "#FFFFFF80"
local text_back_colour       = "#00000066"

frame = 0
firstJumpFrame = 0
frameCount = 0
firstJumpPixel = 0
prevFrameABButtonState = 0
releasedJumpEarly = 0




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
	playerFallGravity = emu.read(ram_Player_Fall_Gravity, 7, 0)
	
	state = emu.getState()
	
	playserStandardXPixel = standardXPixel(playerXPage, playerXPixel)
	
	emu.drawString(11, 200, standardXPixel(playerXPage, playerXPixel), 0xFFFFFF, 0xFF000000)
	
	
	-- clears values
	if playerXPage < 5 or ( playerXPage == 5 and playerXPixel <= 150 ) then
		--emu.log("cleared")  
		frameCount = 0
		firstJumpFrame = 0
		firstJumpPixel = 0
		secondJumpPixel = 0
		releasedJumpEarly = false
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
		
		-- First jump info display
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
	--emu.log(playerFallGravity)
	-- checks if jump was released too early on first pixel jump
	-- playerFallGravity 144 falling/ground, 40 going up?
	if firstJumpPixel == 246 and secondJumpPixel == 0 then
		if playerFallGravity == 144 and playserStandardXPixel >= 1529 and playserStandardXPixel <= 1601 then
			releasedJumpEarly = true
			emu.log("too early")	
		end
	end

	-- for second pixel jump
	if firstJumpPixel == 249 and secondJumpPixel == 0 then
		if playerFallGravity == 144 and playserStandardXPixel >= 1531 and playserStandardXPixel <= 1601 then
			releasedJumpEarly = true
			emu.log("too early")	
		end
	end






	if releasedJumpEarly == true then
		emu.drawString(11, 160, "Released jump too early", 0xFFFFFF, 0xFF000000)
	end















	-- gets second jump pixel
	if firstJumpPixel ~= 0 and secondJumpPixel == 0 and abButtonState == 192 and prevFrameABButtonState ~= 192 and playserStandardXPixel >= 1626 and playserStandardXPixel <= 1641 then
		secondJumpPixel = playserStandardXPixel
	end
		
	-- frame early 1636
	-- first jump was firest pixel
	if firstJumpPixel == 246 and secondJumpPixel ~= 0 then
		emu.log("first")
		if secondJumpPixel == 1639 then
			emu.drawString(11, 180, "First Pixel", 0xFFFFFF, 0xFF000000)
		elseif secondJumpPixel == 1641 then
			emu.drawString(11, 180, "Second Pixel", 0xFFFFFF, 0xFF000000)	
		elseif secondJumpPixel == 1636 then
			emu.drawString(11, 180, "One Frame Early -1", 0xFFFFFF, 0xFF000000)
		elseif secondJumpPixel == 1634 then
			emu.drawString(11, 180, "Two Frames Early -2", 0xFFFFFF, 0xFF000000)
		elseif secondJumpPixel == 1631 then
			emu.drawString(11, 180, "Three Frames Early -3", 0xFFFFFF, 0xFF000000)
		elseif secondJumpPixel == 1629 then
			emu.drawString(11, 180, "Four Frames Early -4", 0xFFFFFF, 0xFF000000)
		elseif secondJumpPixel == 1626 then
			emu.drawString(11, 180, "Five Frames Early -5", 0xFFFFFF, 0xFF000000)
		end
	end
	
	-- first jump was second pixel
	if firstJumpPixel == 249 and secondJumpPixel ~= 0 then
		emu.log("second")
		if secondJumpPixel == 1641 then
			emu.drawString(11, 180, "First (only) Pixel", 0xFFFFFF, 0xFF000000)
		elseif secondJumpPixel == 1639 then
			emu.drawString(11, 180, "One Frame Early -1", 0xFFFFFF, 0xFF000000)
		elseif secondJumpPixel == 1636 then
			emu.drawString(11, 180, "Two Frames Early -2", 0xFFFFFF, 0xFF000000)
		elseif secondJumpPixel == 1634 then
			emu.drawString(11, 180, "Three Frames Early -3", 0xFFFFFF, 0xFF000000)
		elseif secondJumpPixel == 1631 then
			emu.drawString(11, 180, "Four Frames Early -4", 0xFFFFFF, 0xFF000000)
		elseif secondJumpPixel == 1629 then
			emu.drawString(11, 180, "Five Frames Early -5", 0xFFFFFF, 0xFF000000)
		elseif secondJumpPixel == 1626 then
			emu.drawString(11, 180, "Six Frames Early -6", 0xFFFFFF, 0xFF000000)
		end	
	end
	
	
		
	
	prevFrameABButtonState = abButtonState

end

function standardXPixel(p ,x)
	return 256 * p + x
end





emu.addEventCallback(display, emu.eventType.endFrame);