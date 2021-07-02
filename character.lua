local character = {}
character.__index = character

function NewCharacter(n)
	n.stance = "walk"
	n.hasmoved = false
	n.hasattacked = false
	n.movement = 5
	n.tweens = {}
	n.crons = {}
	n.maxhp = 2
	n.hp = n.maxhp
	n.animations = {
		stand = {
			[DIR_NORTH] = NewAnimation(IMG_knight_stand_north,  20, 32, 1, 10),
			[DIR_SOUTH] = NewAnimation(IMG_knight_stand_south,  20, 32, 1, 10),
			[DIR_EAST]  = NewAnimation(IMG_knight_stand_east,  20, 32, 1, 10),
			[DIR_WEST]  = NewAnimation(IMG_knight_stand_west,  20, 32, 1, 10),
		},
		walk = {
			[DIR_NORTH] = NewAnimation(IMG_knight_walk_north,  20, 32, 1, 8),
			[DIR_SOUTH] = NewAnimation(IMG_knight_walk_south,  20, 32, 1, 8),
			[DIR_EAST]  = NewAnimation(IMG_knight_walk_east,  20, 32, 1, 8),
			[DIR_WEST]  = NewAnimation(IMG_knight_walk_west,  20, 32, 1, 8),
		},
		attack = {
			[DIR_NORTH] = NewAnimation(IMG_knight_attack_north,  20, 32, 1, 8),
			[DIR_SOUTH] = NewAnimation(IMG_knight_attack_south,  20, 32, 1, 8),
			[DIR_EAST]  = NewAnimation(IMG_knight_attack_east,  20, 32, 1, 8),
			[DIR_WEST]  = NewAnimation(IMG_knight_attack_west,  20, 32, 1, 8),
		},
		hit = {
			[DIR_NORTH] = NewAnimation(IMG_knight_hit_north,  20, 32, 1, 8),
			[DIR_SOUTH] = NewAnimation(IMG_knight_hit_south,  20, 32, 1, 8),
			[DIR_EAST]  = NewAnimation(IMG_knight_hit_east,  20, 32, 1, 8),
			[DIR_WEST]  = NewAnimation(IMG_knight_hit_west,  20, 32, 1, 8),
		},
		dead = {
			[DIR_NORTH] = NewAnimation(IMG_knight_dead_north,  20, 32, 1, 8),
			[DIR_SOUTH] = NewAnimation(IMG_knight_dead_south,  20, 32, 1, 8),
			[DIR_EAST]  = NewAnimation(IMG_knight_dead_east,  20, 32, 1, 8),
			[DIR_WEST]  = NewAnimation(IMG_knight_dead_west,  20, 32, 1, 8),
		},
	}
	n.anim = n.animations[n.stance][n.direction]
	return setmetatable(n, character)
end

function character:update(dt)
	if self.hp == 0 then
		self:setStance("dead")
	end
	self.anim:update(dt)
	if #self.tweens > 0 then
		if self.tweens[1]:update(dt) then
			table.remove(self.tweens, 1)
		end
	end
	if #self.crons > 0 then
		if self.crons[1]:update(dt) then
			table.remove(self.crons, 1)
		end
	end
end

function character:setStance(s)
	self.stance = s
	self.anim = self.animations[self.stance][self.direction]
end

function character:setDirection(d)
	self.direction = d
	self.anim = self.animations[self.stance][self.direction]
end

function character:move(path, endcb)
	local last = table.remove(path, 1)
	for i = 1, #path do
		local current = path[i]
		local nextdir = GetNewDirection(last.x, last.y, current.x, current.y)
		local mystartcb = function (n)
			n:setDirection(nextdir)
		end
		local myendcb = nil
		if i == #path then
			myendcb = endcb
		end
		table.insert(self.tweens, Tween.new(0.25, self, {x=current.x, y=current.y}, 'linear', mystartcb, myendcb))
		last = current
	end
end

function character:attack(target, endcb)
	local nextdir = GetNewDirection(self.x, self.y, target.x, target.y)
	self:setDirection(nextdir)
	self:setStance("attack")
	table.insert(self.crons, Cron.after(1, endcb))
	table.insert(self.crons, Cron.after(0.01, function ()
		target:setStance("hit")
	end))
	table.insert(self.crons, Cron.after(0.5, function ()
		target.hp = target.hp - 1
		if target.hp <= 0 then
			target.hp = 0
			target:setStance("dead")
		else
			target:setStance("walk")
		end
	end))
end

function character:draw()
	love.graphics.draw(IMG_shadow, self.x*THW - self.y*THW - 10 + THW, self.x*THH + self.y*THH - THH*2 + 30)
	if self.hp == 0 then
		self.anim:draw(self.x*THW - self.y*THW - 10 + THW, self.x*THH + self.y*THH - THH*2 + 14)
	else
		self.anim:draw(self.x*THW - self.y*THW - 10 + THW, self.x*THH + self.y*THH - THH*2 + 6)
	end
	if self.at == 0 and MENU == nil and DIRECTIONS == nil and MOVABLES == nil and ATTACKABLES == nil then
		love.graphics.draw(IMG_at, self.x*THW - self.y*THW - 10 + THW, self.x*THH + self.y*THH - THH*2 + 6)
	end
end
