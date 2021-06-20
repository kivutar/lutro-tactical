require "anim"
require "cursor"
require "character"

RETRO_DEVICE_ID_JOYPAD_B        = 1
RETRO_DEVICE_ID_JOYPAD_Y        = 2
RETRO_DEVICE_ID_JOYPAD_SELECT   = 3
RETRO_DEVICE_ID_JOYPAD_START    = 4
RETRO_DEVICE_ID_JOYPAD_UP       = 5
RETRO_DEVICE_ID_JOYPAD_DOWN     = 6
RETRO_DEVICE_ID_JOYPAD_LEFT     = 7
RETRO_DEVICE_ID_JOYPAD_RIGHT    = 8
RETRO_DEVICE_ID_JOYPAD_A        = 9
RETRO_DEVICE_ID_JOYPAD_X        = 10
RETRO_DEVICE_ID_JOYPAD_L        = 11
RETRO_DEVICE_ID_JOYPAD_R        = 12
RETRO_DEVICE_ID_JOYPAD_L2       = 13
RETRO_DEVICE_ID_JOYPAD_R2       = 14
RETRO_DEVICE_ID_JOYPAD_L3       = 15
RETRO_DEVICE_ID_JOYPAD_R3       = 16

THW=48/2
THH=24/2

CHARS = {}

MAP = {
	{0,0,0,0,0,0,0,0},
	{0,1,1,0,0,0,1,0},
	{0,1,1,0,0,0,1,0},
	{0,0,0,0,0,0,1,0},
	{0,0,0,0,0,0,1,0},
	{0,0,0,0,0,0,1,0},
	{0,1,1,1,1,1,1,0},
	{0,0,0,0,0,0,0,0},
}

TIME_RUNNING = true

function love.load()
	IMG_grass = love.graphics.newImage("assets/grass4.png")
	IMG_water = love.graphics.newImage("assets/water4.png")

	IMG_cursor = love.graphics.newImage("assets/cursor.png")
	IMG_bg = love.graphics.newImage("assets/bg.png")
	IMG_shadow = love.graphics.newImage("assets/shadow.png")
	IMG_at = love.graphics.newImage("assets/at.png")

	IMG_knight_stand_south = love.graphics.newImage("assets/knight_stand_south.png")
	IMG_knight_stand_north = love.graphics.newImage("assets/knight_stand_north.png")
	IMG_knight_stand_west = love.graphics.newImage("assets/knight_stand_west.png")
	IMG_knight_stand_east = love.graphics.newImage("assets/knight_stand_east.png")

	IMG_knight_walk_south = love.graphics.newImage("assets/knight_walk_south.png")
	IMG_knight_walk_north = love.graphics.newImage("assets/knight_walk_north.png")
	IMG_knight_walk_west = love.graphics.newImage("assets/knight_walk_west.png")
	IMG_knight_walk_east = love.graphics.newImage("assets/knight_walk_east.png")

	table.insert(CHARS, NewCharacter({x=2, y=2, direction=1, period=7}))
	table.insert(CHARS, NewCharacter({x=2, y=1, direction=3, period=8}))

	CURSOR = NewCursor({x=1, y=1})
end

function love.update(dt)
	if TIME_RUNNING then
		for i=1, #CHARS do
			CHARS[i].at = CHARS[i].at - 1
			if CHARS[i].at == 0 then
				TIME_RUNNING = false
			end
		end
	end

	for i=1, #CHARS do
		CHARS[i]:update(dt)
	end

	if not TIME_RUNNING then
		CURSOR:update(dt)
	end
end

function love.draw()
	love.graphics.draw(IMG_bg, 0, 0)

	love.graphics.push()
	love.graphics.translate(-THW+160, 0)

	for y = 1, 8 do
		for x = 1, 8 do
			if MAP[y][x] == 0 then
				love.graphics.draw(IMG_water, x*THW - y*THW, x*THH + y*THH)
			else
				love.graphics.draw(IMG_grass, x*THW - y*THW, x*THH + y*THH)
			end
		end
	end

	CURSOR:draw()

	for i=1, #CHARS do
		CHARS[i]:draw()
	end

	love.graphics.pop()
end
