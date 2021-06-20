local cursor = {}
cursor.__index = cursor

function NewCursor(n)
	n.img = IMG_cursor
	return setmetatable(n, cursor)
end

function cursor:update(dt)
	local JOY_LEFT  = love.joystick.isDown(1, RETRO_DEVICE_ID_JOYPAD_LEFT)
	local JOY_RIGHT = love.joystick.isDown(1, RETRO_DEVICE_ID_JOYPAD_RIGHT)
	local JOY_DOWN  = love.joystick.isDown(1, RETRO_DEVICE_ID_JOYPAD_DOWN)
	local JOY_UP    = love.joystick.isDown(1, RETRO_DEVICE_ID_JOYPAD_UP)

	if JOY_DOWN then
		self.y = self.y + 1
	end
	if JOY_UP then
		self.y = self.y - 1
	end
	if JOY_RIGHT then
		self.x = self.x + 1
	end
	if JOY_LEFT then
		self.x = self.x - 1
	end

	if self.x < 1 then self.x = 1 end
	if self.y < 1 then self.y = 1 end
	if self.x >= #MAP then self.x = #MAP end
	if self.y >= #MAP then self.y = #MAP end
end

function cursor:draw()
	love.graphics.draw(self.img, self.x*THW - self.y*THW, self.x*THH + self.y*THH)
end
