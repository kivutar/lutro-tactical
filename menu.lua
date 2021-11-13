local menu = {}
menu.__index = menu

function NewMenu(n)
	n.idx = 1
	n.entries = {
		{title="MOVE", callback=SelectMoveTile},
		{title="ATTACK", callback=SelectAttackTile},
	}
	if CHAR.job == "wizzard" then
		table.insert(n.entries, {title="FIREBALL", callback=SelectFireBallTile})
		table.insert(n.entries, {title="HEAL", callback=SelectHealTile})
	end
	table.insert(n.entries, {title="WAIT", callback=function() Wait(n.pad) end})
	return setmetatable(n, menu)
end

function menu:isActionDisabled(i)
	local e = self.entries[i]
	return (e.title == "MOVE" and CHAR.hasmoved) or
		(e.title == "ATTACK" and CHAR.hasacted) or
		(e.title == "FIREBALL" and CHAR.hasacted) or
		(e.title == "HEAL" and CHAR.hasacted)
end

function menu:update(dt)
	if Input.withCooldown(self.pad, BTN_DOWN) then
		self.idx = self.idx + 1
		SFX_select:play()
	end
	if Input.withCooldown(self.pad, BTN_UP) then
		self.idx = self.idx - 1
		SFX_select:play()
	end

	if self.idx < 1 then self.idx = 1 end
	if self.idx >= #self.entries then self.idx = #self.entries end

	if Input.once(self.pad, BTN_A) then
		if not self:isActionDisabled(self.idx) then
			SFX_ok:play()
			MENU = nil
			self.entries[self.idx].callback()
		end
	end

	if Input.once(self.pad, BTN_B) then
		SFX_cancel:play()
		MENU = nil
	end
end

function menu:draw()
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(IMG_menu, 32-4, 48-4)

	for i=1, #self.entries do
		local e = self.entries[i]
		if self.idx == i then
			if self:isActionDisabled(i) then
				love.graphics.setColor(128,128,128,255)
			else
				love.graphics.setColor(128,0,0,255)
			end
			love.graphics.rectangle("fill", 32, 48+ (i-1)*16, 64, 15)
		end
		love.graphics.setColor(255,255,255,255)
		love.graphics.print(e.title, 32+4, 48+4 + (i-1)*16)
	end
end
