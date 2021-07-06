local directions = {}
directions.__index = directions

function NewDirections(n)
	n.idx = CHAR.direction
	return setmetatable(n, directions)
end

function directions:update(dt)
	if Input.once(1, BTN_DOWN) then
		SFX_select:play()
		DIRECTIONS_IDX = DIR_WEST
	end
	if Input.once(1, BTN_UP) then
		SFX_select:play()
		DIRECTIONS_IDX = DIR_EAST
	end
	if Input.once(1, BTN_LEFT) then
		SFX_select:play()
		DIRECTIONS_IDX = DIR_NORTH
	end
	if Input.once(1, BTN_RIGHT) then
		SFX_select:play()
		DIRECTIONS_IDX = DIR_SOUTH
	end

	CHAR:setDirection(DIRECTIONS_IDX)

	if Input.once(1, BTN_A) then
		SFX_ok:play()
		DIRECTIONS = nil
		TIME_RUNNING = true
		if not CHAR.hasacted or not CHAR.hasmoved then
			CHAR.at = CHAR.period / 2
		else
			CHAR.at = CHAR.period
		end
	end

	if Input.once(1, BTN_B) then
		SFX_cancel:play()
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
		love.graphics.draw(img, t.x*THW - t.y*THW + THW - 4, t.x*THH + t.y*THH + THH - 8 - TH)
	end
end
