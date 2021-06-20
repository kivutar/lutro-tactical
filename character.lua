local character = {}
character.__index = character

function NewCharacter(n)
	n.stance = "walk"
	n.at = n.period
	n.movement = 5
	n.tweens = {}
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
	if #self.tweens > 0 then
		if self.tweens[1]:update(dt) then
			table.remove(self.tweens, 1)
		end
	end
end

function character:move(path)
	table.remove(path, 1)
	for i = 1, #path do
		table.insert(self.tweens, Tween.new(0.5, self, {x=path[i].x, y=path[i].y}, 'linear'))
	end
end

function character:draw()
	love.graphics.draw(IMG_shadow, self.x*THW - self.y*THW - 10 + THW, self.x*THH + self.y*THH - THH*2 + 30)
	self.anim:draw(self.x*THW - self.y*THW - 10 + THW, self.x*THH + self.y*THH - THH*2 + 8)
	if self.at == 0 and MENU == nil then
		love.graphics.draw(IMG_at, self.x*THW - self.y*THW - 10 + THW, self.x*THH + self.y*THH - THH*2 + 8)
	end
end
