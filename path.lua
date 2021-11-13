
function GetNewDirection(x1, y1, x2, y2)
	local dx = x2 - x1
	local dy = y2 - y1

	if (math.abs(dy) > math.abs(dx)) then
		if dy > 0 then return DIR_WEST else return DIR_EAST end
	else
		if dx > 0 then return DIR_SOUTH else return DIR_NORTH end
	end
end

local around = {{x=-1,y=0},{x=1,y=0},{x=0,y=-1},{x=0,y=1}}

function BuildPath(path, tile)
	table.insert(path, 1, tile)
	if tile.parent then
		BuildPath(path, tile.parent)
	end
end

function TileIn(list, item)
	for i = 1, #list do
		if list[i].x == item.x and list[i].y == item.y then
			return list[i]
		end
	end
	return nil
end

function GetMovable(x, y)
	if y <= 0 or y > #MAP then return nil end
	if x <= 0 or x > #MAP[1] then return nil end
	if MAP[y][x] == 0 then return nil end
	for i = 1, #CHARS do
		local c = CHARS[i]
		if c.x == x and c.y == y and c.team ~= CHAR.team and c.hp > 0 then
			return nil
		end
	end
	return {x=x, y=y}
end

function AddMovableToList(pos, list, range)
	if range <= 0 then return end
	pos.visited = true
	if CharInTile(pos) == nil then
		table.insert(list, pos)
	end
	for i = 1, #around do
		local delta = around[i]
		local adj = GetMovable(pos.x + delta.x, pos.y + delta.y)
		if adj ~= nil and not adj.visited then
			if not adj.parent then
				adj.parent = pos
			end
			AddMovableToList(adj, list, range - 1)
		end
	end
end

function GetAttackable(x, y)
	if y <= 0 or y > #MAP then return nil end
	if x <= 0 or x > #MAP[1] then return nil end
	if MAP[y][x] == 0 then return nil end
	return {x=x, y=y}
end

function AddAttackableToList(pos, list, range)
	range = range - 1
	if range <= 0 then return end
	for i = 1, #around do
		local delta = around[i]
		local adjacent = GetAttackable(pos.x + delta.x, pos.y + delta.y)
		if adjacent ~= nil then
			table.insert(list, adjacent)
			AddAttackableToList(adjacent, list, range)
		end
	end
end

function AddMagicableToList(pos, list)
	for i = 1, #around do
		local delta = around[i]
		for range = 1, 8 do
			local t = GetAttackable(pos.x + delta.x*range, pos.y + delta.y*range)
			if t ~= nil then
				table.insert(list, t)
			end
		end
	end
end

function AddHealableToList(pos, list, range)
	if range <= 0 then return end
	pos.visited = true
	table.insert(list, pos)
	for i = 1, #around do
		local delta = around[i]
		local adj = GetAttackable(pos.x + delta.x, pos.y + delta.y)
		if adj ~= nil and not adj.visited then
			if not adj.parent then
				adj.parent = pos
			end
			AddHealableToList(adj, list, range - 1)
		end
	end
end

function SelectMoveTile()
	local movables = {}
	local movement = CHAR.movement
	local rootpos = {x = CHAR.x, y = CHAR.y}
	AddMovableToList(rootpos, movables, movement)
	MOVABLES = movables
end

function SelectAttackTile()
	local attackables = {}
	local rootpos = {x = CHAR.x, y = CHAR.y}
	AddAttackableToList(rootpos, attackables, 2)
	ATTACKABLES = attackables
end

function SelectFireBallTile()
	local attackables = {}
	local rootpos = {x = CHAR.x, y = CHAR.y}
	AddMagicableToList(rootpos, attackables)
	ATTACKABLES = attackables
end

function SelectHealTile()
	local healables = {}
	local rootpos = {x = CHAR.x, y = CHAR.y}
	AddHealableToList(rootpos, healables, 3)
	HEALABLES = healables
end

function Wait(pad)
	DIRECTIONS = NewDirections({pad=pad})
	DIRECTIONS_IDX = CHAR.direction
end

function CharInTile(t)
	for i = 1, #CHARS do
		local c = CHARS[i]
		if c.x == t.x and c.y == t.y then
			return c
		end
	end
	return nil
end
