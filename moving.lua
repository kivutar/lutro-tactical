
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
	--print(tile.x, tile.y)
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
	if x <= 0 or x > #MAP then return nil end
	if MAP[y][x] == 0 then return nil end
	for i = 1, #CHARS do
		local c = CHARS[i]
		if c.x == x and c.y == y then
			return nil
		end
	end
	return {x=x, y=y}
end

function AddToList(pos, list, moves)
	moves = moves - 1
	if moves <= 0 then return end
	for i = 1, #around do
		local delta = around[i]
		local adjacent = GetMovable(pos.x + delta.x, pos.y + delta.y)
		if adjacent ~= nil then
			adjacent.parent = pos
			table.insert(list, adjacent)
			AddToList(adjacent, list, moves)
		end
	end
end

function SelectMoveTile()
	MENU = nil
	local movables = {}
	local movement = CHARS[CHAR_IDX].movement
	local rootpos = {x = CHARS[CHAR_IDX].x, y = CHARS[CHAR_IDX].y}
	AddToList(rootpos, movables, movement)
	MOVABLES = movables
end

function SelectAttackTile()
	
end

function Wait()
	
end

function SelectDirection()
	
end
