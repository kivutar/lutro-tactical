local menu = {}
menu.__index = menu

function MapGet(x, y)
	if y <= 0 or y > #MAP then return nil end
	if x <= 0 or x > #MAP[1] then return nil end
	if MAP[y][x] == 0 then return nil end
	return {x, y}
end

function SelectMoveTile(char)
	MOVING = true
	MENU = nil
	local around = {{x=-1,y=0},{x=1,y=0},{x=0,y=-1},{x=0,y=1}}
	local selected = {}
	for i = 1, #around do
		local delta = around[i]
		local adjacent = MapGet(char.x + delta.x, char.y + delta.y)
		if adjacent ~= nil then table.insert(selected, adjacent) end
	end
	print(#selected)
end

function SelectAttackTile()
	
end

function Wait()
	
end

function SelectDirection()
	
end

function NewMenu(n)
	n.cooldown = 0
	n.idx = 1
	n.entries = {
		{title="MOVE", callback=function() SelectMoveTile(n.char) end},
		{title="ATTACK", callback=SelectAttackTile},
		{title="WAIT", callback=Wait},
	}
	return setmetatable(n, menu)
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
		self.entries[self.idx].callback()
	end

	if JOY_B and self.cooldown == 0 then
		MENU = nil
	end
end

function menu:draw()
	love.graphics.setColor(0,0,0,255)
	love.graphics.rectangle("fill", 32, 48, 64, 64)

	for i=1, #self.entries do
		if self.idx == i then
			love.graphics.setColor(128,0,0,255)
			love.graphics.rectangle("fill", 32, 48+ (i-1)*16, 64, 16)
		end
		local e = self.entries[i]
		love.graphics.setColor(255,255,255,255)
		love.graphics.print(e.title, 32+5, 48+5 + (i-1)*16)
	end
end
