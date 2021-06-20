local character = {}
character.__index = character

function NewCharacter(n)
	n.stance = "walk"
	n.at = n.period
	n.movement = 5
	n.tweens = {}
	n.animations = {
		stand = {
			[DIR_NORTH] = NewAnimation(IMG_knight_stand_north,  20, 32, 1, 10),
			[DIR_SOUTH] = NewAnimation(IMG_knight_stand_south,  20, 32, 1, 10),
			[DIR_EAST]  = NewAnimation(IMG_knight_stand_east,  20, 32, 1, 10),
			[DIR_WEST]  = NewAnimation(IMG_knight_stand_west,  20, 32, 1, 10),
		},
		walk = {
			[DIR_NORTH] = NewAnimation(IMG_knight_walk_north,  20, 32, 1, 2),
			[DIR_SOUTH] = NewAnimation(IMG_knight_walk_south,  20, 32, 1, 2),
			[DIR_EAST]  = NewAnimation(IMG_knight_walk_east,  20, 32, 1, 2),
			[DIR_WEST]  = NewAnimation(IMG_knight_walk_west,  20, 32, 1, 2),
		},
	}
	n.anim = n.animations[n.stance][n.direction]
	return setmetatable(n, character)
end

function character:update(dt)
	self.anim:update(dt)
	if #self.tweens > 0 then
		if self.tweens[1]:update(dt) then
			table.remove(self.tweens, 1)
		end
	end
end

function character:move(path)
	local last = table.remove(path, 1)
	for i = 1, #path do
		local current = path[i]
		local nextdir = GetNewDirection(last.x, last.y, current.x, current.y)
		local cb = function (n)
			n.direction = nextdir
			n.anim = n.animations[n.stance][n.direction]
		end
		table.insert(self.tweens, Tween.new(0.3, self, {x=current.x, y=current.y}, 'linear', cb))
		last = current
	end
end

function character:draw()
	love.graphics.draw(IMG_shadow, self.x*THW - self.y*THW - 10 + THW, self.x*THH + self.y*THH - THH*2 + 30)
	self.anim:draw(self.x*THW - self.y*THW - 10 + THW, self.x*THH + self.y*THH - THH*2 + 8)
	if self.at == 0 and MENU == nil then
		love.graphics.draw(IMG_at, self.x*THW - self.y*THW - 10 + THW, self.x*THH + self.y*THH - THH*2 + 8)
	end
end
