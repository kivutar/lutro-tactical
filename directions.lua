local directions = {}
directions.__index = directions

function NewDirections(n)
	n.cooldown = 30
	n.idx = CHARS[CHAR_IDX].direction
	return setmetatable(n, directions)
end

function directions:update(dt)
	if self.cooldown > 0 then self.cooldown = self.cooldown - 1 end

	local JOY_DOWN  = love.joystick.isDown(1, RETRO_DEVICE_ID_JOYPAD_DOWN)
	local JOY_UP    = love.joystick.isDown(1, RETRO_DEVICE_ID_JOYPAD_UP)
	local JOY_LEFT  = love.joystick.isDown(1, RETRO_DEVICE_ID_JOYPAD_LEFT)
	local JOY_RIGHT = love.joystick.isDown(1, RETRO_DEVICE_ID_JOYPAD_RIGHT)
	local JOY_A    = love.joystick.isDown(1, RETRO_DEVICE_ID_JOYPAD_A)
	local JOY_B    = love.joystick.isDown(1, RETRO_DEVICE_ID_JOYPAD_B)

	if JOY_DOWN then DIRECTIONS_IDX = DIR_WEST end
	if JOY_UP then DIRECTIONS_IDX = DIR_EAST end
	if JOY_LEFT then DIRECTIONS_IDX = DIR_NORTH end
	if JOY_RIGHT then DIRECTIONS_IDX = DIR_SOUTH end

	CHARS[CHAR_IDX]:setDirection(DIRECTIONS_IDX)

	if JOY_A and self.cooldown == 0 then
		DIRECTIONS = nil
		TIME_RUNNING = true
		CHARS[CHAR_IDX].at = CHARS[CHAR_IDX].period
	end

	if JOY_B then DIRECTIONS = nil end
end

function directions:draw()
	local around = {{x=-0.5,y=0},{x=0.5,y=0},{x=0,y=-0.5},{x=0,y=0.5}}
	for i = 1, #around do
		local delta = around[i]
		local t = {x = CHARS[CHAR_IDX].x + delta.x, y=CHARS[CHAR_IDX].y + delta.y}
		local img = IMG_direction
		if i == DIRECTIONS_IDX then
			img = IMG_direction_active
		end
		love.graphics.draw(img, t.x*THW - t.y*THW + THW - 4, t.x*THH + t.y*THH + THH - 4 - TH)
	end
end