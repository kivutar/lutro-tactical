local directions = {}
directions.__index = directions

function NewDirections(n)
	n.idx = CHAR.direction
	return setmetatable(n, directions)
end

function directions:update(dt)
	if Input.justPressed(1, BTN_DOWN) then DIRECTIONS_IDX = DIR_WEST end
	if Input.justPressed(1, BTN_UP) then DIRECTIONS_IDX = DIR_EAST end
	if Input.justPressed(1, BTN_LEFT) then DIRECTIONS_IDX = DIR_NORTH end
	if Input.justPressed(1, BTN_RIGHT) then DIRECTIONS_IDX = DIR_SOUTH end

	CHAR:setDirection(DIRECTIONS_IDX)

	if Input.justPressed(1, BTN_A) then
		Input.reset(1, BTN_A)
		DIRECTIONS = nil
		TIME_RUNNING = true
		CHAR.at = CHAR.period
	end

	if Input.justPressed(1, BTN_B) then
		Input.reset(1, BTN_B)
		DIRECTIONS = nil
	end
end

function directions:draw()
	local around = {{x=-0.5,y=0},{x=0.5,y=0},{x=0,y=-0.5},{x=0,y=0.5}}

	for i = 1, #around do
		local delta = around[i]
		local char = CHAR
		local t = {x = char.x + delta.x, y = char.y + delta.y}
		local img = IMG_direction
		if i == DIRECTIONS_IDX then
			img = IMG_direction_active
		end
		love.graphics.draw(img, t.x*THW - t.y*THW + THW - 4, t.x*THH + t.y*THH + THH - 4 - TH)
	end
end
