local menu = {}
menu.__index = menu

function NewMenu(n)
	n.cooldown = 30
	n.idx = 1
	n.entries = {
		{title="MOVE", callback=SelectMoveTile},
		{title="ATTACK", callback=SelectAttackTile},
		{title="WAIT", callback=Wait},
	}
	return setmetatable(n, menu)
end

function menu:isActionDisabled(i)
	local e = self.entries[i]
	return (e.title == "MOVE" and CHARS[CHAR_IDX].hasmoved) or (e.title == "ATTACK" and CHARS[CHAR_IDX].hasattacked)
end

function menu:update(dt)
	if self.cooldown > 0 then self.cooldown = self.cooldown - 1 end

	local JOY_DOWN  = love.joystick.isDown(1, RETRO_DEVICE_ID_JOYPAD_DOWN)
	local JOY_UP    = love.joystick.isDown(1, RETRO_DEVICE_ID_JOYPAD_UP)
	local JOY_A    = love.joystick.isDown(1, RETRO_DEVICE_ID_JOYPAD_A)
	local JOY_B    = love.joystick.isDown(1, RETRO_DEVICE_ID_JOYPAD_B)

	if JOY_DOWN and self.cooldown == 0 then
		self.idx = self.idx + 1
		self.cooldown = 10
	end
	if JOY_UP and self.cooldown == 0 then
		self.idx = self.idx - 1
		self.cooldown = 10
	end

	if self.idx < 1 then self.idx = 1 end
	if self.idx >= #self.entries then self.idx = #self.entries end

	if JOY_A and self.cooldown == 0 then
		self.cooldown = 10
		if not self:isActionDisabled(self.idx) then
			MENU = nil
			self.entries[self.idx].callback()
		end
	end

	if JOY_B and self.cooldown == 0 then
		self.cooldown = 10
		MENU = nil
	end
end

function menu:draw()
	love.graphics.setColor(0,0,0,255)
	love.graphics.rectangle("fill", 32, 48, 64, 64)

	for i=1, #self.entries do
		local e = self.entries[i]
		if self.idx == i then
			if self:isActionDisabled(i) then
				love.graphics.setColor(128,128,128,255)
			else
				love.graphics.setColor(128,0,0,255)
			end
			love.graphics.rectangle("fill", 32, 48+ (i-1)*16, 64, 16)
		end
		love.graphics.setColor(255,255,255,255)
		love.graphics.print(e.title, 32+5, 48+5 + (i-1)*16)
	end
end
