local cursor = {}
cursor.__index = cursor

function NewCursor(n)
	n.img = IMG_cursor
	return setmetatable(n, cursor)
end

function cursor:warp(n)
	self.x = n.x
	self.y = n.y
end

function cursor:update(dt)
	if Input.withCooldown(1, BTN_DOWN) then
		self.y = self.y + 1
		SFX_select:play()
	end
	if Input.withCooldown(1, BTN_UP) then
		self.y = self.y - 1
		SFX_select:play()
	end
	if Input.withCooldown(1, BTN_RIGHT) then
		self.x = self.x + 1
		SFX_select:play()
	end
	if Input.withCooldown(1, BTN_LEFT) then
		self.x = self.x - 1
		SFX_select:play()
	end

	if Input.once(1, BTN_A) then

		if MOVABLES ~= nil then
			local destination = TileIn(MOVABLES, self)
			if destination ~= nil and CharInTile(destination) == nil then
				SFX_ok:play()
				local path = {}
				BuildPath(path, destination)
				local endcb = function ()
					MOVABLES = nil
					MENU = nil
					CHAR.hasmoved = true
					if not CHAR.hasattacked then
						MENU = NewMenu()
					end
					if CHAR.hasmoved and CHAR.hasattacked then
						Wait()
					end
				end
				CHAR:move(path, endcb)
			end
		elseif ATTACKABLES ~= nil then
			for i = 1, #CHARS do
				local target = CHARS[i]
				local curr = CHAR
				if target.x == self.x and target.y == self.y
					and not (target.x == curr.x and target.y == curr.y)
					and target.hp > 0 then
					SFX_ok:play()
					ATTACKABLES = nil
					MENU = nil
					local endcb = function ()
						CHAR.hasattacked = true
						CHAR:setStance("walk")
						if not CHAR.hasmoved then
							MENU = NewMenu()
						end
						if CHAR.hasmoved and CHAR.hasattacked then
							Wait()
						end
					end
					CHAR:attack(target, endcb)
				end
			end
		else
			for i = 1, #CHARS do
				local char = CHARS[i]
				if char.x == self.x and char.y == self.y and char.at == 0 then
					MENU = NewMenu()
				end
			end
		end
	end

	if Input.once(1, BTN_B) then
		SFX_cancel:play()
		if MOVABLES ~= nil then MOVABLES = nil end
		if ATTACKABLES ~= nil then ATTACKABLES = nil end
	end

	if self.x < 1 then self.x = 1 end
	if self.y < 1 then self.y = 1 end
	if self.x >= #MAP[1] then self.x = #MAP[1] end
	if self.y >= #MAP then self.y = #MAP end
end

function cursor:draw()
	love.graphics.draw(self.img, self.x*THW - self.y*THW, self.x*THH + self.y*THH)
end
