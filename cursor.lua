local cursor = {}
cursor.__index = cursor

function NewCursor(n)
	n.t = 0
	return setmetatable(n, cursor)
end

function cursor:warp(n)
	self.x = n.x
	self.y = n.y
end

function cursor:update(dt)
	self.t = self.t + 0.05

	if Input.withCooldown(self.pad, BTN_DOWN) then
		self.y = self.y + 1
		SFX_select:play()
	end
	if Input.withCooldown(self.pad, BTN_UP) then
		self.y = self.y - 1
		SFX_select:play()
	end
	if Input.withCooldown(self.pad, BTN_RIGHT) then
		self.x = self.x + 1
		SFX_select:play()
	end
	if Input.withCooldown(self.pad, BTN_LEFT) then
		self.x = self.x - 1
		SFX_select:play()
	end

	if Input.once(self.pad, BTN_A) then

		if MOVABLES ~= nil then
			local destination = TileIn(MOVABLES, self)
			if destination ~= nil and CharInTile(destination) == nil then

				SFX_ok:play()

				local okcb = function ()
					local path = {}
					BuildPath(path, destination)
					local endcb = function ()
						MOVABLES = nil
						MENU = nil
						CHAR.hasmoved = true
						if not CHAR.hasacted then
							MENU = NewMenu({pad=CHAR.team})
						end
						if CHAR.hasmoved and CHAR.hasacted then
							Wait(self.pad)
						end
					end
					CHAR:move(path, endcb)
				end

				local cancelcb = function ()
					MENU = nil
				end

				MENU = NewConfirmation({okcb=okcb, cancelcb=cancelcb, pad=self.pad})

			end
		elseif ATTACKABLES ~= nil then
			for i = 1, #CHARS do
				local target = CHARS[i]
				local curr = CHAR
				if target.x == self.x and target.y == self.y
					and not (target.x == curr.x and target.y == curr.y)
					and target.hp > 0 then

					SFX_ok:play()

					local okcb = function ()
						ATTACKABLES = nil
						MENU = nil
						TARGETED = nil
						local endcb = function ()
							CHAR.hasacted = true
							CHAR:setStance("walk")
							if not CHAR.hasmoved then
								MENU = NewMenu({pad=CHAR.team})
							end
							if CHAR.hasmoved and CHAR.hasacted then
								Wait(self.pad)
							end
						end
						CHAR:attack(target, endcb)
					end

					local cancelcb = function ()
						MENU = nil
						TARGETED = nil
					end

					TARGETED = {self}
					MENU = NewConfirmation({okcb=okcb, cancelcb=cancelcb, pad=self.pad})

				end
			end
		elseif HEALABLES ~= nil then
			for i = 1, #CHARS do
				local target = CHARS[i]
				local curr = CHAR
				if target.x == self.x and target.y == self.y
					and not (target.x == curr.x and target.y == curr.y)
					and target.hp > 0 then

					SFX_ok:play()

					local okcb = function ()
						HEALABLES = nil
						MENU = nil
						TARGETED = nil
						local endcb = function ()
							CHAR.hasacted = true
							CHAR:setStance("walk")
							if not CHAR.hasmoved then
								MENU = NewMenu({pad=CHAR.team})
							end
							if CHAR.hasmoved and CHAR.hasacted then
								Wait(self.pad)
							end
						end
						CHAR:heal(target, endcb)
					end

					local cancelcb = function ()
						MENU = nil
						TARGETED = nil
					end

					TARGETED = {self}
					MENU = NewConfirmation({okcb=okcb, cancelcb=cancelcb})

				end
			end
		else
			for i = 1, #CHARS do
				local char = CHARS[i]
				if char.x == self.x and char.y == self.y and char.at == 0 then
					SFX_ok:play()
					MENU = NewMenu({pad=CHAR.team})
				end
			end
		end
	end

	if Input.once(self.pad, BTN_B) then
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
	love.graphics.draw(IMG_cursor, self.x*THW - self.y*THW, self.x*THH + self.y*THH)
end

function cursor:draw2()
	love.graphics.draw(IMG_cursorarrow, self.x*THW - self.y*THW + 16, self.x*THH + self.y*THH - 32 - math.cos(self.t)*2)
end
