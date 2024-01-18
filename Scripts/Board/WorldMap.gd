extends TileMap
class_name WorldMap

var hexDatabase:Dictionary
var worldSize:int = 8 #current "stage/max map size in rings from center

var updateOrder:Array[Vector2i] #Add tile coords to this array to add them to the update queue
#Use Array.has() to make sure it isnt added twice

func WorldSetup():
	var worldHexes:Array[Vector2i] = GetAllHexes(worldSize)
	
	for tile in worldHexes:
		var newHex:Hex = Hex.new()
		var hexData:TileData = get_cell_tile_data(0, tile)
		newHex.gridCoords = tile
		newHex.tileType = hexData.get_custom_data("Tile Ruleset")
		newHex.stackCount = hexData.get_custom_data("Stack Count")
		newHex.tags = newHex.tileType.tagsDatabase
		hexDatabase[tile] = newHex
	
	#print(hexDatabase)

func WorldTurn():
	updateOrder = GetAllHexes(worldSize)
	#print(updateOrder)
	UpdateWorld()

func UpdateWorld(): #This is a loop that iterates through every hex, in priority order
	while updateOrder.size() > 0:
		var tile = updateOrder.pop_front()
		if hexDatabase.has(tile):
			print("Current Updating Tile: ", tile, " Current Tile Type: ", hexDatabase[tile].tileType.name)
			hexDatabase[tile].tileType.UpdateHex(self, tile)
	pass
	#Make sure to skip any hex that has already updated, or been newly placed this turn
	#Be sure to remove tile coords from updateOrder if they've been changed by anything in this function

func GetAdjacent(coords:Vector2i, directionIndex:int) -> Vector2i:
	if directionIndex == 1:
		return get_neighbor_cell(coords, TileSet.CELL_NEIGHBOR_TOP_SIDE)
	elif directionIndex == 2:
		return get_neighbor_cell(coords, TileSet.CELL_NEIGHBOR_TOP_RIGHT_SIDE)
	elif directionIndex == 3:
		return get_neighbor_cell(coords, TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_SIDE)
	elif directionIndex == 4:
		return get_neighbor_cell(coords, TileSet.CELL_NEIGHBOR_BOTTOM_SIDE)
	elif directionIndex == 5:
		return get_neighbor_cell(coords, TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_SIDE)
	elif directionIndex == 6:
		return get_neighbor_cell(coords, TileSet.CELL_NEIGHBOR_TOP_LEFT_SIDE)
	
	return Vector2i(0,0)

func GetAllAdjacent(coords:Vector2i) -> Array:
	var neighbors:Array[Vector2i]
	neighbors.append(get_neighbor_cell(coords, TileSet.CELL_NEIGHBOR_TOP_SIDE))
	neighbors.append(get_neighbor_cell(coords, TileSet.CELL_NEIGHBOR_TOP_RIGHT_SIDE))
	neighbors.append(get_neighbor_cell(coords, TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_SIDE))
	neighbors.append(get_neighbor_cell(coords, TileSet.CELL_NEIGHBOR_BOTTOM_SIDE))
	neighbors.append(get_neighbor_cell(coords, TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_SIDE))
	neighbors.append(get_neighbor_cell(coords, TileSet.CELL_NEIGHBOR_TOP_LEFT_SIDE))
	return neighbors

func GetAllHexes(mapSize:int) -> Array:
	var hexes:Array[Vector2i]
	var currentHex:Vector2i
	var currentRing:int = 1
	var directionOrder:Array[int] = [3,4,5,6,1,2] #This creates a clockwise circle, starting from the top
	
	currentHex = Vector2i(0,0)
	hexes.append(currentHex) #Start at the center hex, spiral outwards
	
	while currentRing < mapSize:
		currentHex = get_neighbor_cell(currentHex, TileSet.CELL_NEIGHBOR_TOP_SIDE)
		if get_cell_tile_data(0, currentHex) != null and !hexes.has(currentHex):
			hexes.append(currentHex)
		#print("New Ring! Starting at: ", currentHex)
		for direction in directionOrder:
			#print("New Direction! Aiming towards: ", direction)
			for i in range(currentRing):
				currentHex = GetAdjacent(currentHex, direction)
				#print(currentHex)
				if get_cell_tile_data(0, currentHex) != null and !hexes.has(currentHex):
					hexes.append(currentHex)
					#print("Found new hex, adding: ", currentHex)
		currentRing += 1
	
	return hexes

func ChangeStack(coords:Vector2i, amount:int):
	var targetTile:Hex = hexDatabase[coords]
	#play sound from targetTile.tileType.soundScale, scale position based on stack, octave based on +/-
	#As long as the amount change wouldn't take it below 0 or above max, change amount.
	if targetTile.stackCount + amount > 0 and targetTile.stackCount + amount < targetTile.tileType.stackMax:
		targetTile.stackCount += amount
	elif targetTile.stackCount + amount <= 0:
		pass
		#NoStackTrig(targetTile)
	elif targetTile.stackCount + amount >= targetTile.tileType.stackMax:
		pass
		#MaxStackTrig(targetTile)

func ChangeTags(coords:Vector2i, tagsToAdd:Dictionary, soft:bool=false): 
	#Swap out tags on target tile. If "soft", adds tags instead of replacing.
	var targetTile:Hex = hexDatabase[coords]
	
	if targetTile != null:
		if soft == false:
			targetTile.tags = tagsToAdd
		else:
			for tag in tagsToAdd:
				if !targetTile.tags.has(tag):
					targetTile.tags[tag] = tagsToAdd[tag]
				elif targetTile.tags.has(tag) and targetTile.tags[tag] == false:
					targetTile.tags[tag] = true

func ChangeTile(coords:Vector2i, type:TileRuleset, stacks:int=1, soft:bool=false): 
	#Swap out target tile. If "soft", adds tags to resulting tile's tags. Optionally set stack count, default 1.
	var targetTile:Hex = hexDatabase[coords]
	#play random sound from targetTile.tileType.soundScale
	if targetTile != null:
		if targetTile.tags.has("Irreplacable") and targetTile.tags["Irreplacable"] == false:
			set_cell(0, coords, 2, type.tileIndex) #add stack count as alternate tile, needs RESEARCH
			targetTile.tileType = type
			targetTile.stackCount = stacks
			ChangeTags(coords, type.tagsDatabase, soft)

