BTN_B        = 1
BTN_Y        = 2
BTN_SELECT   = 3
BTN_START    = 4
BTN_UP       = 5
BTN_DOWN     = 6
BTN_LEFT     = 7
BTN_RIGHT    = 8
BTN_A        = 9
BTN_X        = 10
BTN_L        = 11
BTN_R        = 12
BTN_L2       = 13
BTN_R2       = 14
BTN_L3       = 15
BTN_R3       = 16

local state = {{[BTN_R3] = 0}, {[BTN_R3] = 0}}

return {
	update = function()
		for pad = 1, 2 do
			for btn = 1, 16 do
				if love.joystick.isDown(pad, btn) then
					state[pad][btn] = state[pad][btn] + 1
				else
					state[pad][btn] = 0
				end
			end
		end
	end,
	isDown = function (pad, btn)
		return state[pad][btn] > 0
	end,
	once = function (pad, btn)
		local val = state[pad][btn] == 1
		if val then state[pad][btn] = state[pad][btn] + 1 end
		return val
	end,
	withCooldown = function (pad, btn)
		return state[pad][btn] % 8 == 1
	end,
	reset = function (pad, btn)
		state[pad][btn] = 0
	end
}
