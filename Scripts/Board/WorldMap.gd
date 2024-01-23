extends TileMap
class_name WorldMap

var hexDatabase:Dictionary
var worldSize:int = 10 #current "stage/max map size in rings from center

var updateOrder:Array[Vector2i] #Add tile coords to this array to add them to the update queue
#Use Array.has() to make sure it isnt added twice

func WorldSetup():
	var worldHexes:Array[Vector2i] = GetAllHexes(worldSize)
	
	for tile in worldHexes:
		var hexData:TileData = get_cell_tile_data(0, tile)
		if hexData == null:
			worldHexes.erase(tile)
			print("No Cell")
		var newHex:Hex = Hex.new()
		newHex.gridCoords = tile
		newHex.tileType = hexData.get_custom_data("Tile Ruleset")
		newHex.stackCount = hexData.get_custom_data("Stack Count")
		newHex.tags = newHex.tileType.tagsDatabase.duplicate()
		newHex.counter = newHex.tileType.counterStart
		var newTopper:Sprite2D = Sprite2D.new()
		add_child(newTopper)
		newTopper.texture = hexData.get_custom_data("Topper")
		newTopper.position = to_global(map_to_local(tile))
		newTopper.y_sort_enabled = true
		newTopper.z_index = 1
		print("Topper position: ", newTopper.position, " Topper Texture: ", newTopper.texture)
		newHex.topper = newTopper
		newHex.topperPosition = newTopper.position
		newHex.UpdateHexSprite(self)
		#if newHex.stackCount > 3: Might not need this edge case, but leaving it here anyways
			#newHex.tags["Open"] = false
			#newHex.tags["Blocked"] = true
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
			#print("Current Updating Tile: ", tile, " Current Tile Type: ", hexDatabase[tile].tileType.name)
			hexDatabase[tile].tileType.UpdateHex(self, tile)
			hexDatabase[tile].UpdateHexSprite(self)
	pass
	#Make sure to skip any hex that has already updated, or been newly placed this turn
	#Be sure to remove tile coords from updateOrder if they've been changed by anything in this function

func GetDirection(coords:Vector2i, targetCoords:Vector2i) -> int:
	var direction:int = 0
	#Iterate through directions from coords, checking if cell_neighbor equals target coords, return match
	var neighborCoords:Vector2i
	while targetCoords != neighborCoords:
		direction += 1
		neighborCoords = GetAdjacent(coords, direction)
		#print("Direction Index: ", direction)
	return direction

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
	var TS = get_neighbor_cell(coords, TileSet.CELL_NEIGHBOR_TOP_SIDE)
	if get_cell_tile_data(0, TS) != null:		neighbors.append(TS)
	var TRS = get_neighbor_cell(coords, TileSet.CELL_NEIGHBOR_TOP_RIGHT_SIDE)
	if get_cell_tile_data(0, TRS) != null:		neighbors.append(TRS)
	var BRS = get_neighbor_cell(coords, TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_SIDE)
	if get_cell_tile_data(0, BRS) != null:		neighbors.append(BRS)
	var BS = get_neighbor_cell(coords, TileSet.CELL_NEIGHBOR_BOTTOM_SIDE)
	if get_cell_tile_data(0, BS) != null:		neighbors.append(BS)
	var BLS = get_neighbor_cell(coords, TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_SIDE)
	if get_cell_tile_data(0, BLS) != null:		neighbors.append(BLS)
	var TLS = get_neighbor_cell(coords, TileSet.CELL_NEIGHBOR_TOP_LEFT_SIDE)
	if get_cell_tile_data(0, TLS) != null:		neighbors.append(TLS)
	#print(neighbors)
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

func GetAcross(coords:Vector2i, targetCoords:Vector2i) -> Vector2i:
	var tileAcross:Vector2i
	#get direction of target tile compared to current, then get adjacent in that direction from target
	var direction = GetDirection(coords, targetCoords)
	tileAcross = GetAdjacent(targetCoords, direction)
	return tileAcross

func ChangeStack(coords:Vector2i, amount:int):
	var targetTile:Hex = hexDatabase[coords]
	#play sound from targetTile.tileType.soundScale, scale position based on stack, octave based on +/-
	#As long as the amount change wouldn't take it below 0 or above max, change amount.
	if targetTile == null:
		return
	if targetTile.stackCount + amount > 0 and targetTile.stackCount + amount <= targetTile.tileType.stackMax:
		targetTile.stackCount += amount
		set_cell(0, coords, 0, targetTile.tileType.tileIndex + Vector2i(targetTile.stackCount-1, 0))
		#Add line of code to progress tile's spritesheet "animation set" or variant/alt
	elif targetTile.stackCount + amount <= 0:
		pass
		#NoStackTrig(targetTile)
	elif targetTile.stackCount + amount > targetTile.tileType.stackMax:
		pass
		#print("Tile at Maximum Stacks!")
		#MaxStackTrig(targetTile)

func ChangeTags(coords:Vector2i, tagsToAdd:Dictionary): 
	var targetTile:Hex = hexDatabase[coords]
	if targetTile == null:
		return
	for tag in tagsToAdd:
		targetTile.tags[tag] = tagsToAdd[tag]

func AddRemoveTag(coords:Vector2i, tag:String, tagState:bool):
	var targetTile:Hex = hexDatabase[coords]
	if targetTile == null:
		return
	targetTile.tags[tag] = tagState

func ChangeTile(coords:Vector2i, type:TileRuleset, stacks:int=1, soft:bool=false): 
	#Swap out target tile. If "soft", adds tags to resulting tile's tags. Optionally set stack count, default 1.
	print(type)
	var targetTile:Hex = hexDatabase[coords]
	print("Changing Tile ", coords, " to ", type.name)
	#play random sound from targetTile.tileType.soundScale
	if targetTile == null:
		return
	if targetTile.tags.has("Irreplacable") and targetTile.tags["Irreplacable"] == false:
		targetTile.tileType = type
		targetTile.stackCount = stacks
		targetTile.counter = type.counterStart
		if targetTile.counter != -1:
			print("Counter: ", targetTile.counter)
		#Keep tile graphic atlas to tile types going vertical, stacks going horizontal. New columns OK
		set_cell(0, coords, 0, type.tileIndex + Vector2i(targetTile.stackCount-1, 0))
		ChangeTags(coords, type.tagsDatabase)

func ChangeEntity(coords:Vector2i, entity:Entity, forceReplace:bool=false): 
	#Swap out target entity/worker.
	var targetTile:Hex = hexDatabase[coords]
	if targetTile == null:
		return
	if targetTile.entityOnTile != null and forceReplace == false:
		return
	if targetTile.entityOnTile.entityTags["Irreplacable"] == true:
		return
	targetTile.entityOnTile = entity
	#Change entity graphic out for new

func ChangeTopper(coords:Vector2i, topperSprite:Sprite2D, additive:bool):
	pass
