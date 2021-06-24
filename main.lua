require "global"
require "anim"
require "cursor"
require "character"
require "menu"
require "path"
require "directions"
Tween = require "tween"

MAP = {
	{0,0,0,0,0,0,0,0},
	{0,1,1,0,0,0,1,0},
	{0,1,1,1,0,0,1,0},
	{0,0,0,1,1,1,1,0},
	{0,0,0,1,1,1,1,0},
	{0,0,0,0,0,0,1,0},
	{0,1,1,1,1,1,1,0},
	{0,0,0,0,0,0,0,0},
}

function love.load()
	IMG_grass = love.graphics.newImage("assets/grass4.png")
	IMG_water = love.graphics.newImage("assets/water4.png")

	IMG_cursor = love.graphics.newImage("assets/cursor.png")
	IMG_bg = love.graphics.newImage("assets/bg.png")
	IMG_shadow = love.graphics.newImage("assets/shadow.png")
	IMG_at = love.graphics.newImage("assets/at.png")
	IMG_movetile = love.graphics.newImage("assets/movetile.png")
	IMG_attacktile = love.graphics.newImage("assets/attacktile.png")
	IMG_direction = love.graphics.newImage("assets/direction.png")
	IMG_direction_active = love.graphics.newImage("assets/direction_active.png")

	IMG_knight_stand_south = love.graphics.newImage("assets/knight_stand_south.png")
	IMG_knight_stand_north = love.graphics.newImage("assets/knight_stand_north.png")
	IMG_knight_stand_west = love.graphics.newImage("assets/knight_stand_west.png")
	IMG_knight_stand_east = love.graphics.newImage("assets/knight_stand_east.png")

	IMG_knight_walk_south = love.graphics.newImage("assets/knight_walk_south.png")
	IMG_knight_walk_north = love.graphics.newImage("assets/knight_walk_north.png")
	IMG_knight_walk_west = love.graphics.newImage("assets/knight_walk_west.png")
	IMG_knight_walk_east = love.graphics.newImage("assets/knight_walk_east.png")

	FNT_letters = love.graphics.newImageFont("assets/letters.png", "ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789.!?")
	love.graphics.setFont(FNT_letters)

	table.insert(CHARS, NewCharacter({x=3, y=3, direction=DIR_SOUTH, period=7}))
	table.insert(CHARS, NewCharacter({x=3, y=2, direction=DIR_SOUTH, period=8}))

	CURSOR = NewCursor({x=1, y=1})
end

function love.update(dt)
	if TIME_RUNNING then
		for i=1, #CHARS do
			CHARS[i].at = CHARS[i].at - 1
			if CHARS[i].at == 0 then
				CHARS[i].hasmoved = false
				CHARS[i].hasattacked = false
				TIME_RUNNING = false
				CHAR_IDX = i
			end
		end
	end

	for i=1, #CHARS do
		CHARS[i]:update(dt)
	end

	if not TIME_RUNNING and MENU == nil and DIRECTIONS == nil then
		CURSOR:update(dt)
	end

	if MENU ~= nil then
		MENU:update(dt)
	end

	if DIRECTIONS ~= nil then
		DIRECTIONS:update(dt)
	end
end

function love.draw()
	love.graphics.draw(IMG_bg, 0, 0)

	love.graphics.push()
	love.graphics.translate(-THW+160, 0)

	for y = 1, 8 do
		for x = 1, 8 do
			if MAP[y][x] == 0 then
				love.graphics.draw(IMG_water, x*THW - y*THW, x*THH + y*THH + 9)
			else
				love.graphics.draw(IMG_grass, x*THW - y*THW, x*THH + y*THH)
			end
		end
	end

	if MOVABLES ~= nil then
		for i=1, #MOVABLES do
			local t = MOVABLES[i]
			love.graphics.draw(IMG_movetile, t.x*THW - t.y*THW, t.x*THH + t.y*THH)
		end
	end

	if ATTACKABLES ~= nil then
		for i=1, #ATTACKABLES do
			local t = ATTACKABLES[i]
			love.graphics.draw(IMG_attacktile, t.x*THW - t.y*THW, t.x*THH + t.y*THH)
		end
	end

	if DIRECTIONS ~= nil then
		DIRECTIONS:draw()
	end

	if DIRECTIONS == nil and MENU == nil then
		CURSOR:draw()
	end

	for i=1, #CHARS do
		CHARS[i]:draw()
	end

	love.graphics.pop()

	if MENU ~= nil then
		MENU:draw()
	end
end
