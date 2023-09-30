jumpXPage = 3
jumpXPixel = 118


ttXPage = 3
ttXPixel = 18


local ram_Player_X_Page         = 0x06D
local ram_Player_X_Pixel        = 0x086

prevXPixel = 0
progressBarWidth = 0

function someFunction()

	playerXPage = emu.read(ram_Player_X_Page, 7, 0)
	playerXPixel = emu.read(ram_Player_X_Pixel, 7, 0)
	
	emu.drawString(11, 120, "xPixel: " .. tostring(playerXPixel), 0xFFFFFF, 0xFF000000)

	--emu.drawRectangle(x, y, width, height, color, fill [, duration, delay])
	--emu.drawLine(x, y, x2, y2, color [, duration, delay])

	if playerXPage < 3 or playerXPixel < 18 then
		prevXPixel = 0
		progressBarWidth = 0
	end


	-- draws main box after reaching a pixel
	if playerXPage == 3 and playerXPixel >= 18 then
		emu.drawRectangle(62, 220, 100, 10, 0x0000FF, 0)	
		emu.drawRectangle(63, 221, 98, 8, 0xFFFFFF, 1)
		emu.drawLine(103, 221, 103, 228, 0x0070DD)
		prevXPixel = playerXPixel
	end
	
	if prevXPixel ~= 0  and prevXPixel == playerXPixel then
		progressBarWidth = progressBarWidth + 1
		if progressBarWidth <= 98 then
			emu.drawRectangle(63, 221, progressBarWidth, 8, 0x3FC7EB, 1)	
		end
	end

-- outer box
--emu.drawRectangle(62, 220, 100, 10, 0x0000FF, 0)
-- inner box
--emu.drawRectangle(63, 221, 98, 8, 0xFFFFFF, 1)
-- progress box
--emu.drawRectangle(63, 221, 25, 8, 0x3FC7EB, 1)
-- jump line
--emu.drawLine(110, 221, 110, 228, 0x0070DD)

end



function someFunction2()

	playerXPage = emu.read(ram_Player_X_Page, 7, 0)
	playerXPixel = emu.read(ram_Player_X_Pixel, 7, 0)
	
	emu.drawString(11, 120, "xPixel: " .. tostring(playerXPixel), 0xFFFFFF, 0xFF000000)

	--emu.drawRectangle(x, y, width, height, color, fill [, duration, delay])
	--emu.drawLine(x, y, x2, y2, color [, duration, delay])
	
	-- 118 - 143
	-- 91 - 116
	-- 63 - 88
	-- 38 - 61	
	-- 13 - 36

	if playerXPage < 3 or playerXPixel < 13 then
		prevXPixel = 0
		progressBarWidth = 0
	end


	-- draws main box after reaching a pixel
	if playerXPage == 3 and playerXPixel >= 18 then
		emu.drawRectangle(62, 220, 92, 10, 0x0000FF, 0)	
		emu.drawRectangle(63, 221, 90, 8, 0xFFFFFF, 1)
		--emu.drawLine(103, 221, 103, 228, 0x0070DD)
		prevXPixel = playerXPixel
	end
	
	if playerXPage == 3 and playerXPixel >= 13 then
		emu.drawRectangle(63, 221, 30, 8, 0xC41E3A, 1)	
	end
	if playerXPage == 3 and playerXPixel >= 38 then
		--emu.drawRectangle(83, 221, 20, 8, 0xA330C9, 1)	
	end
	if playerXPage == 3 and playerXPixel >= 63 then
		emu.drawRectangle(93, 221, 30, 8, 0xFF7C0A, 1)	
	end
	if playerXPage == 3 and playerXPixel >= 91 then
		--emu.drawRectangle(123, 221, 20, 8, 0x33937F, 1)	
	end	
	if playerXPage == 3 and playerXPixel >= 118 then
		emu.drawRectangle(123, 221, 30, 8, 0x3FC7EB, 1)	
	end	
	
	
	
	--[[
	if prevXPixel ~= 0  and prevXPixel == playerXPixel then
		progressBarWidth = progressBarWidth + 1
		if progressBarWidth <= 98 then
			emu.drawRectangle(63, 221, progressBarWidth, 8, 0x3FC7EB, 1)	
		end
	end
	--]]

-- outer box
--emu.drawRectangle(62, 220, 100, 10, 0x0000FF, 0)
-- inner box
--emu.drawRectangle(63, 221, 98, 8, 0xFFFFFF, 1)
-- progress box
--emu.drawRectangle(63, 221, 25, 8, 0x3FC7EB, 1)
-- jump line
--emu.drawLine(110, 221, 110, 228, 0x0070DD)


end




emu.addEventCallback(someFunction2, emu.eventType.endFrame);




