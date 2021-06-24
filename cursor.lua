local cursor = {}
cursor.__index = cursor

function NewCursor(n)
	n.img = IMG_cursor
	n.cooldown = 30
	return setmetatable(n, cursor)
end

function cursor:update(dt)
	if self.cooldown > 0 then self.cooldown = self.cooldown - 1 end

	local JOY_LEFT  = love.joystick.isDown(1, RETRO_DEVICE_ID_JOYPAD_LEFT)
	local JOY_RIGHT = love.joystick.isDown(1, RETRO_DEVICE_ID_JOYPAD_RIGHT)
	local JOY_DOWN  = love.joystick.isDown(1, RETRO_DEVICE_ID_JOYPAD_DOWN)
	local JOY_UP    = love.joystick.isDown(1, RETRO_DEVICE_ID_JOYPAD_UP)
	local JOY_A     = love.joystick.isDown(1, RETRO_DEVICE_ID_JOYPAD_A)
	local JOY_B     = love.joystick.isDown(1, RETRO_DEVICE_ID_JOYPAD_B)

	if JOY_DOWN and self.cooldown == 0 then
		self.y = self.y + 1
		self.cooldown = 10
	end
	if JOY_UP and self.cooldown == 0 then
		self.y = self.y - 1
		self.cooldown = 10
	end
	if JOY_RIGHT and self.cooldown == 0 then
		self.x = self.x + 1
		self.cooldown = 10
	end
	if JOY_LEFT and self.cooldown == 0 then
		self.x = self.x - 1
		self.cooldown = 10
	end

	if JOY_A and self.cooldown == 0 then
		self.cooldown = 10

		if MOVABLES ~= nil then
			local destination = TileIn(MOVABLES, self)
			if destination ~= nil then
				local path = {}
				BuildPath(path, destination)
				local endcb = function ()
					MOVABLES = nil
					MENU = nil
					CHARS[CHAR_IDX].hasmoved = true
					if not CHARS[CHAR_IDX].hasattacked then
						MENU = NewMenu({})
					end
					if CHARS[CHAR_IDX].hasmoved and CHARS[CHAR_IDX].hasattacked then
						TIME_RUNNING = true
						CHARS[CHAR_IDX].at = CHARS[CHAR_IDX].period
					end
				end
				CHARS[CHAR_IDX]:move(path, endcb)
			end
		else
			for i = 1, #CHARS do
				local char = CHARS[i]
				if char.x == self.x and char.y == self.y and char.at == 0 then
					MENU = NewMenu({})
				end
			end
		end
	end

	if JOY_B and self.cooldown == 0 then
		self.cooldown = 10
		if MOVABLES ~= nil then MOVABLES = nil end
	end

	if self.x < 1 then self.x = 1 end
	if self.y < 1 then self.y = 1 end
	if self.x >= #MAP then self.x = #MAP end
	if self.y >= #MAP then self.y = #MAP end
end

function cursor:draw()
	love.graphics.draw(self.img, self.x*THW - self.y*THW, self.x*THH + self.y*THH)
end
