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

recordInputs = false
jumpInputs = {}
firstJumpFrame = 0
firstJumpFramesHeld = 0
firstSecondJumpFrame = 0
landingFrame = 0

good = "waiting"

function display()
	--gui.text(1, 41, string.format("XPos:%03d", memory.readbyte(ram_Player_Rel_XPos)), text_colour, text_back_colour)
	--test = memory.readbyte(ram_Player_Rel_XPos)
	--emu.drawString(11, 140, "Jumps: " .. memory.readbyte(ram_Player_Rel_XPos), 0xFFFFFF, 0xFF000000)
	floatState = emu.read(ram_Player_Float_State, 7, 0)
	playerXPage = emu.read(ram_Player_X_Page, 7, 0)
	--playerXPixel = formatXPixel(emu.read(ram_Player_X_Pixel, 7, 1))
	playerXPixel = emu.read(ram_Player_X_Pixel, 7, 0)
	-- 0 no buttons, 128 jump(A) only, 64 run(B) only, 192 both
	abButtonState = emu.read(ram_AB_Button_State, 7, 0)
	playerState = emu.read(ram_Player_State, 7, 0)
	
	--[[
	emu.drawString(11, 110, "AB Button: " .. abButtonState, 0xFFFFFF, 0xFF000000)
	emu.drawString(11, 120, "X Page: " .. playerXPage, 0xFFFFFF, 0xFF000000)
	emu.drawString(11, 130, "X Pixel: " .. playerXPixel, 0xFFFFFF, 0xFF000000)
	emu.drawString(11, 140, "State: " .. playerState, 0xFFFFFF, 0xFF000000)
	emu.drawString(11, 150, "X Pixel*: " .. playerXPixel, 0xFFFFFF, 0xFF000000)
	--floatState
	if playerXPage < 3 or ( playerXPage == 3 and playerXPixel < 75 ) then
		good = "waiting"
	end
	
	if playerXPage == 3 and playerXPixel < 121 and abButtonState == 192 then
		good = "too early"
	end

	if playerXPixel == 121 and playerXPage == 3 and floatState == 1 and good ~= "too early" then
		good = "good2222222222222222222222222222222222"
	end
	
	if playerXPixel == 123 and playerXPage == 3 and floatState == 1 and good ~= "too early" then
		good = "+1"
	end

	emu.drawString(11, 160, good, 0xFFFFFF, 0xFF000000)
	--]]
	
	state = emu.getState()	
	
	--jumpInputs[abButtonState, state["frameCount"], floatState]
	
	-- records inputs if enabled
	if recordInputs then
		jumpInputs[#jumpInputs+1] = {state["frameCount"], abButtonState, floatState, playerState}
	end
	
	-- clears and resets values
	if playerXPixel < 91 and playerXPage <= 3 then
		firstJumpFrame = 0
		firstJumpFramesHeld = 0
		landingFrame = 0
		firstSecondJumpFrame = 0
		firstSecondJumpCalculated = false
		foundLandingFrame = false
		recordInputs = false
		emu.log("should clear")
	end

	-- clears input value and starts recording jump input and states before jump
	if playerXPixel == 91 and playerXPage == 3 then
		recordInputs = true
		jumpInputs = {}
		jumpInputs[1] = {state["frameCount"], abButtonState, floatState, playerState}	
		-- 17 frames
	end
	
	-- stops recording inputs if player dies
	if playerState == 11 then
		recordInputs = false
	end
	
	-- stops recording inputs after enemies cleared
	if playerXPixel > 250 and playerXPage == 3 then
		recordInputs = false
	end
	
	-- finds first jump frame
	if recordInputs == true and firstJumpFrame == 0 then
		for i=2, #jumpInputs do
			if jumpInputs[i][2] == 192 and jumpInputs[i-1][2] == 64 then
				firstJumpFrame = i
				--emu.log("jumped on: " .. i)
			else
				--emu.log("no jump?")
			end
		end
	end
	
	-- how many frames jump was held
	if recordInputs == true and firstJumpFrame ~= 0 and firstJumpFramesHeld == 0 then
		for i=firstJumpFrame, #jumpInputs do
			if jumpInputs[i][2] ~= 192 then
				firstJumpFramesHeld = i - firstJumpFrame
				break
			end
		end
		firstSecondJumpCalculated = false
	end
	--emu.drawString(11, 220, "framesheld: " .. firstJumpFramesHeld, 0xFFFFFF, 0xFF000000)	


	-- displays how accurate first jump was
	if firstJumpFrame == 8 then
		emu.drawString(11, 160, "1: five frames early " .. firstJumpFrame .. " (" .. firstJumpFramesHeld .. ")", 0xFFFFFF, 0xFF000000)
	elseif firstJumpFrame == 9 then
		emu.drawString(11, 160, "1: four frames early " .. firstJumpFrame .. " (" .. firstJumpFramesHeld .. ")", 0xFFFFFF, 0xFF000000)
	elseif firstJumpFrame == 10 then
		emu.drawString(11, 160, "1: three frames early " .. firstJumpFrame .. " (" .. firstJumpFramesHeld .. ")", 0xFFFFFF, 0xFF000000)
	elseif firstJumpFrame == 11 then
		emu.drawString(11, 160, "1: two frames early " .. firstJumpFrame .. " (" .. firstJumpFramesHeld .. ")", 0xFFFFFF, 0xFF000000)
	elseif firstJumpFrame == 12 then
		emu.drawString(11, 160, "1: one frame early " .. firstJumpFrame .. " (" .. firstJumpFramesHeld .. ")", 0xFFFFFF, 0xFF000000)
	elseif firstJumpFrame == 13 then
		emu.drawString(11, 160, "1: first frame " .. firstJumpFrame .. " (" .. firstJumpFramesHeld .. ")", 0xFFFFFF, 0xFF000000)	
	elseif firstJumpFrame == 14 then
		emu.drawString(11, 160, "1: second frame " .. firstJumpFrame .. " (" .. firstJumpFramesHeld .. ")", 0xFFFFFF, 0xFF000000)
	elseif firstJumpFrame == 15 then
		emu.drawString(11, 160, "1: third frame " .. firstJumpFrame .. " (" .. firstJumpFramesHeld .. ")", 0xFFFFFF, 0xFF000000)
	elseif firstJumpFrame == 16 then
		emu.drawString(11, 160, "1: fourth frame " .. firstJumpFrame .. " (" .. firstJumpFramesHeld .. ")", 0xFFFFFF, 0xFF000000)
	elseif firstJumpFrame == 17 then
		emu.drawString(11, 160, "1: fifth frame " .. firstJumpFrame .. " (" .. firstJumpFramesHeld .. ")", 0xFFFFFF, 0xFF000000)
	end
	
	
	if firstJumpFramesHeld ~= 0 and firstJumpFrame >= 13 and firstSecondJumpCalculated == false then
		emu.log("odkdokdo")
		-- first frame jump
		if firstJumpFrame == 13 then
			if firstJumpFramesHeld == 1 then
				secondJumpFrameWindow = 5
				-- 1 frame (5 frame window for second jump)
			elseif firstJumpFramesHeld == 2 then
				secondJumpFrameWindow = 3
				-- 2 frame (3 frame window for second jump)
			elseif firstJumpFramesHeld == 3 then
				secondJumpFrameWindow = 2
				-- 3 frame (2 frame window for second jump)
			elseif firstJumpFramesHeld >= 4 then
				secondJumpFrameWindow = 0
				-- 4+ frame (death)
			end
		end
		-- second frame jump
		if firstJumpFrame == 14 then
			if firstJumpFramesHeld == 1 then
				secondJumpFrameWindow = 4
				-- 1 frame (4 frame window for second jump)
			elseif firstJumpFramesHeld == 2 then
				secondJumpFrameWindow = 2
				-- 2 frame (2 frame window for second jump)
			elseif firstJumpFramesHeld == 3 then
				secondJumpFrameWindow = 1
				-- 3 frame (1 frame window for second jump)
			elseif firstJumpFramesHeld >= 4 then
				secondJumpFrameWindow = 0
				-- 4+ frame (death)
			end
		end
		-- third frame jump
		if firstJumpFrame == 15 then
			if firstJumpFramesHeld == 1 then
				secondJumpFrameWindow = 3
				-- 1 frame (3 frame window for second jump)
			elseif firstJumpFramesHeld == 2 then
				secondJumpFrameWindow = 1
				-- 2 frame (1 frame window for second jump)
			elseif firstJumpFramesHeld >= 3 then
				secondJumpFrameWindow = 0
				-- 3 frame (death)
			end
		end
		-- fourth frame jump
		if firstJumpFrame == 16 then
			if firstJumpFramesHeld == 1 then
				secondJumpFrameWindow = 2
				-- 1 frame (2 frame window for second jump)
			elseif firstJumpFramesHeld >= 2 then
				secondJumpFrameWindow = 0
				-- 2 frame (death)
			end
		end	
		-- fifth frame jump
		if firstJumpFrame == 17 then
			if firstJumpFramesHeld == 1 then
				secondJumpFrameWindow = 1
				-- 1 frame (1 frame window for second jump)
			elseif firstJumpFramesHeld >= 2 then
				secondJumpFrameWindow = 0
				-- 2 frame (death)
			end
		end	
		-- 6+ frame jump (hit koopa)
		if firstJumpFrame >= 18 then
			secondJumpFrameWindow = 0
			-- death
		end
		--emu.drawString(11, 190, "jump window: " .. secondJumpFrameWindow, 0xFFFFFF, 0xFF000000)
		firstSecondJumpCalculated = true
	end
	
	if firstSecondJumpCalculated == true then
		emu.drawString(11, 180, "jump window: " .. secondJumpFrameWindow, 0xFFFFFF, 0xFF000000)
	end
	
	
	
	
	-- firstSecondJumpFrame
	
	-- finds first second jump frame
	if recordInputs == true and firstJumpFramesHeld ~= 0 then
		for i=firstJumpFrame + firstJumpFramesHeld, #jumpInputs do
			if jumpInputs[i][2] == 192 and jumpInputs[i-1][2] == 64 then
				firstSecondJumpFrame = i
				--emu.log("2nd jumped frame: " .. i)
			else
				--emu.log("no jump?")
			end
		end
	end	
	
	-- finds landing frame
	-- jumpInputs[1] = {state["frameCount"], abButtonState, floatState, playerState}
	
	if recordInputs == true and firstJumpFrame ~= 0 and firstJumpFramesHeld ~= 0 and floatState == 0 and foundLandingFrame == false then
		landingFrame = #jumpInputs
		foundLandingFrame = true
	end

	
	
	
	if firstSecondJumpFrame > 0 and landingFrame > 0 and secondJumpFrameWindow ~= 0 then
		someVar = firstSecondJumpFrame - landingFrame
		if someVar <= -1 then
			emu.drawString(11, 170, "2: 2+ early", 0xFFFFFF, 0xFF000000)
		elseif someVar == 0 then
			emu.drawString(11, 170, "2: one frame early", 0xFFFFFF, 0xFF000000)
		elseif someVar == 1 then
			emu.drawString(11, 170, "2: first frame", 0xFFFFFF, 0xFF000000)
		elseif someVar == 2 then
			emu.drawString(11, 170, "2: second frame", 0xFFFFFF, 0xFF000000)
		elseif someVar == 3 then
			emu.drawString(11, 170, "2: third frame", 0xFFFFFF, 0xFF000000)
		elseif someVar == 4 then
			emu.drawString(11, 170, "2: fourth frame", 0xFFFFFF, 0xFF000000)
		elseif someVar == 5 then
			emu.drawString(11, 170, "2: fifth frame", 0xFFFFFF, 0xFF000000)
		end
	end
	

	--emu.log("land: " .. landingFrame)
	--emu.log(firstSecondJumpFrame)
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	if jumpInputs[#jumpInputs] == 192 and jumpInputs[#jumpInputs-1] ~= 192 then
		emu.drawString(11, 80, jumpInputs[#jumpInputs], 0xFFFFFF, 0xFF000000)	
	end
	
	
	
	--emu.drawString(11, 100, jumpInputs[#jumpInputs], 0xFFFFFF, 0xFF000000)
	--emu.drawString(11, 100, "jump*: " ..  #jumpInputs, 0xFFFFFF, 0xFF000000)
	--emu.drawString(11, 90, "frame: " ..  jumpInputs[1][1], 0xFFFFFF, 0xFF000000)



--[[	

	if playerXPage < 3 or (playerXPage == 3 and playerXPixel >=0 and playerXPixel < 121 ) then
		good = "waiting"
	end
	
	if playerXPage == 3 and playerXPixel == 118 and floatState == 1 then
		good = "too early"
	end
	
	if playerXPixel == 121 and playerXPage == 3 and floatState == 1 and good ~= "too early" then
		good = "yes"
	end
	
	--if playerXPage == 3 and playerXPixel > 50 and playerXPixel < 121 and floatState == 1 then
	--	good = "too early"
	--end
	

	
	if good == "yes" then
		emu.drawString(11, 160, "good", 0xFFFFFF, 0xFF000000)
	else
	if good == "too early" then
		emu.drawString(11, 160, "too early", 0xFFFFFF, 0xFF000000)
	end
	end
--]]
	
	

	
	
	

end





emu.addEventCallback(display, emu.eventType.endFrame);