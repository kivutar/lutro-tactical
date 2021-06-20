require "anim"
require "character"

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

function love.load()
	IMG_grass = love.graphics.newImage("grass4.png")
	IMG_water = love.graphics.newImage("water4.png")

	IMG_knight_stand_south = love.graphics.newImage("knight_stand_south.png")
	IMG_knight_stand_north = love.graphics.newImage("knight_stand_north.png")
	IMG_knight_stand_west = love.graphics.newImage("knight_stand_west.png")
	IMG_knight_stand_east = love.graphics.newImage("knight_stand_east.png")

	IMG_knight_walk_south = love.graphics.newImage("knight_walk_south.png")
	IMG_knight_walk_north = love.graphics.newImage("knight_walk_north.png")
	IMG_knight_walk_west = love.graphics.newImage("knight_walk_west.png")
	IMG_knight_walk_east = love.graphics.newImage("knight_walk_east.png")

	table.insert(CHARS, NewCharacter({x=2, y=2, direction=1}))
	table.insert(CHARS, NewCharacter({x=2, y=1, direction=3}))
end

function love.update(dt)
	for i=1, #CHARS do
		CHARS[i]:update(dt)
	end
end

THW=48/2
THH=24/2

function love.draw()
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
	for i=1, #CHARS do
		CHARS[i]:draw()
	end
	love.graphics.pop()
end
