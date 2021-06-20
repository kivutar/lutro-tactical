local character = {}
character.__index = character

function NewCharacter(n)
	n.stance = "walk"
	n.at = n.period
	n.animations = {
		stand = {
			[0] = NewAnimation(IMG_knight_stand_north,  20, 32, 1, 10),
			[1] = NewAnimation(IMG_knight_stand_south,  20, 32, 1, 10),
			[2] = NewAnimation(IMG_knight_stand_east,  20, 32, 1, 10),
			[3] = NewAnimation(IMG_knight_stand_west,  20, 32, 1, 10),
		},
		walk = {
			[0] = NewAnimation(IMG_knight_walk_north,  20, 32, 1, 2),
			[1] = NewAnimation(IMG_knight_walk_south,  20, 32, 1, 2),
			[2] = NewAnimation(IMG_knight_walk_east,  20, 32, 1, 2),
			[3] = NewAnimation(IMG_knight_walk_west,  20, 32, 1, 2),
		},
	}
	n.anim = n.animations[n.stance][n.direction]
	return setmetatable(n, character)
end

function character:update(dt)
	self.anim:update(dt)
end

function character:draw()
	love.graphics.draw(IMG_shadow, self.x*THW - self.y*THW - 10 + THW, self.x*THH + self.y*THH + 30)
	self.anim:draw(self.x*THW - self.y*THW - 10 + THW, self.x*THH + self.y*THH + 8)
	if self.at == 0 then
		love.graphics.draw(IMG_at, self.x*THW - self.y*THW - 10 + THW, self.x*THH + self.y*THH + 8)
	end
end
