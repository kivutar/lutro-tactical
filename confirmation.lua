local confirmation = {}
confirmation.__index = confirmation

function NewConfirmation(n)
	n.idx = 1
	n.entries = {
		{title="OK", callback=n.okcb},
		{title="CANCEL", callback=n.cancelcb},
	}
	return setmetatable(n, confirmation)
end

function confirmation:update(dt)
	if Input.withCooldown(1, BTN_DOWN) then
		self.idx = self.idx + 1
		SFX_select:play()
	end
	if Input.withCooldown(1, BTN_UP) then
		self.idx = self.idx - 1
		SFX_select:play()
	end

	if self.idx < 1 then self.idx = 1 end
	if self.idx >= #self.entries then self.idx = #self.entries end

	if Input.once(1, BTN_A) then
		SFX_ok:play()
		MENU = nil
		self.entries[self.idx].callback()
	end

	if Input.once(1, BTN_B) then
		SFX_cancel:play()
		MENU = nil
	end
end

function confirmation:draw()
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(IMG_yesno, 32-4, 48-4)

	for i=1, #self.entries do
		local e = self.entries[i]
		if self.idx == i then
			love.graphics.setColor(128,0,0,255)
			love.graphics.rectangle("fill", 32, 48+ (i-1)*16, 64, 15)
		end
		love.graphics.setColor(255,255,255,255)
		love.graphics.print(e.title, 32+4, 48+4 + (i-1)*16)
	end
end
