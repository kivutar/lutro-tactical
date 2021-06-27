local menu = {}
menu.__index = menu

function NewMenu()
	local n = {}
	n.idx = 1
	n.entries = {
		{title="MOVE", callback=SelectMoveTile},
		{title="ATTACK", callback=SelectAttackTile},
		{title="WAIT", callback=Wait},
	}
	return setmetatable(n, menu)
end

function menu:isActionDisabled(i)
	local e = self.entries[i]
	return (e.title == "MOVE" and CHAR.hasmoved) or (e.title == "ATTACK" and CHAR.hasattacked)
end

function menu:update(dt)
	if Input.withCooldown(1, BTN_DOWN) then
		self.idx = self.idx + 1
	end
	if Input.withCooldown(1, BTN_UP) then
		self.idx = self.idx - 1
	end

	if self.idx < 1 then self.idx = 1 end
	if self.idx >= #self.entries then self.idx = #self.entries end

	if Input.once(1, BTN_A) then
		if not self:isActionDisabled(self.idx) then
			MENU = nil
			self.entries[self.idx].callback()
		end
	end

	if Input.once(1, BTN_B) then
		MENU = nil
	end
end

function menu:draw()
	love.graphics.setColor(0,0,0,255)
	love.graphics.rectangle("fill", 32, 48, 64, 64)

	for i=1, #self.entries do
		local e = self.entries[i]
		if self.idx == i then
			if self:isActionDisabled(i) then
				love.graphics.setColor(128,128,128,255)
			else
				love.graphics.setColor(128,0,0,255)
			end
			love.graphics.rectangle("fill", 32, 48+ (i-1)*16, 64, 16)
		end
		love.graphics.setColor(255,255,255,255)
		love.graphics.print(e.title, 32+5, 48+5 + (i-1)*16)
	end
end
