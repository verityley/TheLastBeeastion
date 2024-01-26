extends TileMap
class_name WorldMap

var hexDatabase:Dictionary
@export var worldSize:int = 20 #current "stage/max map size in rings from center

@export var dampTexture:Texture2D
@export var fertileTexture:Texture2D

var updateOrder:Array[Vector2i] #Add tile coords to this array to add them to the update queue
var entityOrder:Array[Entity]
var changedOrder:Array[Vector2i]
var stackedOrder:Array[Vector2i]

var availableWorkers:int = 1
var workerMax:int = 1
@export var honey:int = 0
#@export var wait:bool
#@export var turnIcon:Texture2D
#var turnTracker:Sprite2D
#var frameTracker:float
#var frameThreshold:float = 0.5
#Use Array.has() to make sure it isnt added twice

#func _process(delta):
	#frameTracker += delta
	#print(frameTracker)

func WorldSetup():
	var worldHexes:Array[Vector2i] = GetAllHexes(worldSize)
	#turnTracker = Sprite2D.new()
	#add_child(turnTracker)
	#turnTracker.hide()
	#turnTracker.texture = turnIcon
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
		newHex.priorStack = newHex.stackCount
		var newTopper:Sprite2D = Sprite2D.new()
		add_child(newTopper)
		newTopper.texture = hexData.get_custom_data("Topper")
		newTopper.position = to_global(map_to_local(tile)) + (Vector2(0,-20)*newHex.stackCount)
		var flip = RandomNumberGenerator.new().randi_range(0,1)
		if flip == 0:
			newTopper.flip_h = false
		elif flip == 1:
			newTopper.flip_h = true
		newTopper.y_sort_enabled = true
		newTopper.z_index = 4
		#print("Topper position: ", newTopper.position, " Topper Texture: ", newTopper.texture)
		newHex.topper = newTopper
		newHex.topperPosition = newTopper.position
		var dampRing:Sprite2D = Sprite2D.new()
		add_child(dampRing)
		dampRing.hide()
		dampRing.texture = dampTexture
		dampRing.position = to_global(map_to_local(tile)) + (Vector2(0,-40+(float(newHex.stackCount-1)* -20)))
		dampRing.y_sort_enabled = true
		dampRing.z_index = 1
		var fertileRing:Sprite2D = Sprite2D.new()
		add_child(fertileRing)
		fertileRing.hide()
		fertileRing.texture = fertileTexture
		fertileRing.position = to_global(map_to_local(tile)) + (Vector2(0,-40+(float(newHex.stackCount-1)* -20)))
		fertileRing.y_sort_enabled = true
		fertileRing.z_index = 2
		newHex.dampIndicator = dampRing
		newHex.fertileIndicator = fertileRing
		newHex.UpdateHexSprite(self)
		#if newHex.stackCount > 3: Might not need this edge case, but leaving it here anyways
			#newHex.tags["Open"] = false
			#newHex.tags["Blocked"] = true
		hexDatabase[tile] = newHex
	ChangeEntity(Vector2i(0,0), HexTypes.entity["Hive"], true)
	ChangeEntity(Vector2i(0,-3), HexTypes.entity["Sapling Goal"], true)
	#ChangeEntity(Vector2i(-9,4), HexTypes.entity["Geyser"], true)
	#ChangeEntity(Vector2i(15,-8), HexTypes.entity["Volcano"], true)
	#print(hexDatabase)

func WorldTurn():
	#frameTracker = 0
	updateOrder = GetAllHexes(worldSize)
	
	#print(updateOrder)
	#if wait:
		#turnTracker.show()
	UpdateWorld()
	for tile in GetAllHexes(worldSize):
		hexDatabase[tile].alreadyChanged = false
	print("Current Honey Stocks: ", honey)
	#$ChangedPlayer.UpdateBacklog(self, changedOrder.duplicate())
	#$StackedPlayer.UpdateBacklog(self, stackedOrder.duplicate())
	#if changedOrder.size() > 0:
		#$ChangedPlayer.PlayBacklog()
	#if stackedOrder.size() > 0:
		#$StackedPlayer.PlayBacklog()
	#changedOrder.clear()
	#stackedOrder.clear()

func UpdateWorld(): #This is a loop that iterates through every hex, in priority order
	while updateOrder.size() > 0:
		var tile = updateOrder.pop_front()
		if hexDatabase.has(tile):
			#print("Current Updating Tile: ", tile, " Current Tile Type: ", hexDatabase[tile].tileType.name)
			hexDatabase[tile].tileType.UpdateHex(self, tile)
			hexDatabase[tile].tileType.UpdateOnTile(self, tile)
			hexDatabase[tile].UpdateHexSprite(self)
			#if wait == true:
				#turnTracker.position = to_global(map_to_local(tile))
				#await frameTracker >= frameThreshold
				#frameTracker = 0 + (frameTracker - frameThreshold)
	#if wait:
		#turnTracker.hide()
		#$Timer.wait_time = 0.1
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

func GetRadiusHexes(coords:Vector2i, radius:int) -> Array:
	var hexes:Array[Vector2i]
	var currentHex:Vector2i
	var currentRing:int = 1
	var directionOrder:Array[int] = [3,4,5,6,1,2] #This creates a clockwise circle, starting from the top
	
	currentHex = coords
	hexes.append(currentHex) #Start at the center hex, spiral outwards
	
	while currentRing <= radius:
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
		#frameThreshold = 0.5 / currentRing
	return hexes

func GetHexRing(coords:Vector2i, ring:int) -> Array:
	var hexes:Array[Vector2i]
	var currentHex:Vector2i
	var directionOrder:Array[int] = [3,4,5,6,1,2] #This creates a clockwise circle, starting from the top
	
	currentHex = Vector2i(coords.x,coords.y-ring)
	if get_cell_tile_data(0, currentHex) != null and !hexes.has(currentHex):
		hexes.append(currentHex)
	#print("New Ring! Starting at: ", currentHex)
	for direction in directionOrder:
		#print("New Direction! Aiming towards: ", direction)
		for i in range(ring):
			currentHex = GetAdjacent(currentHex, direction)
			#print(currentHex)
			if get_cell_tile_data(0, currentHex) != null and !hexes.has(currentHex):
				hexes.append(currentHex)
				#print("Found new hex, adding: ", currentHex)
	return hexes

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
			if hexDatabase.has(currentHex):
				hexDatabase[currentHex].ring = currentRing
		#print("New Ring! Starting at: ", currentHex)
		for direction in directionOrder:
			#print("New Direction! Aiming towards: ", direction)
			for i in range(currentRing):
				currentHex = GetAdjacent(currentHex, direction)
				#print(currentHex)
				if get_cell_tile_data(0, currentHex) != null and !hexes.has(currentHex):
					hexes.append(currentHex)
					if hexDatabase.has(currentHex):
						hexDatabase[currentHex].ring = currentRing
					#print("Found new hex, adding: ", currentHex)
		currentRing += 1
		#frameThreshold = 0.5 / currentRing
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
	if targetTile.alreadyChanged:
		return
	if targetTile.stackCount + amount > 0 and targetTile.stackCount + amount <= targetTile.tileType.stackMax:
		targetTile.stackCount += amount
		#Add line of code to progress tile's spritesheet "animation set" or variant/alt
	elif targetTile.stackCount + amount <= 0:
		targetTile.stackCount = 1
		#NoStackTrig(targetTile)
	elif targetTile.stackCount + amount > targetTile.tileType.stackMax:
		targetTile.stackCount = targetTile.tileType.stackMax
		#print("Tile at Maximum Stacks!")
		#MaxStackTrig(targetTile)
	stackedOrder.append(coords)
	set_cell(0, coords, 0, targetTile.tileType.tileIndex + Vector2i(targetTile.stackCount-1, 0))
	targetTile.UpdateHexSprite(self)

func ChangeTags(coords:Vector2i, tagsToAdd:Dictionary): 
	var targetTile:Hex = hexDatabase[coords]
	if targetTile == null:
		return
	if targetTile.alreadyChanged:
		return
	for tag in tagsToAdd:
		targetTile.tags[tag] = tagsToAdd[tag]

func AddRemoveTag(coords:Vector2i, tag:String, tagState:bool):
	var targetTile:Hex = hexDatabase[coords]
	if targetTile == null:
		return
	if targetTile.alreadyChanged:
		return
	targetTile.tags[tag] = tagState

func ChangeTile(coords:Vector2i, type:TileRuleset, stacks:int=1, soft:bool=false): 
	#Swap out target tile. If "soft", adds tags to resulting tile's tags. Optionally set stack count, default 1.
	#print(type)
	var targetTile:Hex = hexDatabase[coords]
	#print("Changing Tile ", coords, " to ", type.name)
	#play random sound from targetTile.tileType.soundScale
	if targetTile == null:
		return
	if targetTile.tags["Irreplacable"] == true:
		return
	if targetTile.alreadyChanged:
		return
	if targetTile.tags["Irreplacable"] == false:
		targetTile.tileType = type
		targetTile.stackCount = stacks
		targetTile.counter = type.counterStart
		#if targetTile.counter != -1:
			#print("Counter: ", targetTile.counter)
		#Keep tile graphic atlas to tile types going vertical, stacks going horizontal. New columns OK
		changedOrder.append(coords)
		set_cell(0, coords, 0, type.tileIndex + Vector2i(targetTile.stackCount-1, 0))
		ChangeTags(coords, type.tagsDatabase)
		targetTile.UpdateHexSprite(self)

func ChangeEntity(coords:Vector2i, entity:Entity, forceReplace:bool=false): 
	#Swap out target entity/worker.
	var targetTile:Hex = hexDatabase[coords]
	if targetTile == null:
		return
	if targetTile.entityOnTile != null and forceReplace == false:
		return
	elif targetTile.entityOnTile != null and forceReplace == true:
		#if targetTile.entityOnTile.entityTags.has("Irreplacable"):
		#	return
		remove_child(targetTile.entityOnTile.entitySprite)
		if (targetTile.entityOnTile.name == "Worker" or 
			targetTile.entityOnTile.name == "Gardener" or 
			targetTile.entityOnTile.name == "Builder"):
			availableWorkers += 1
		if targetTile.entityOnTile.name == "Hive":
			availableWorkers -= 1
			workerMax -= 1
	if entity == null:
		targetTile.entityOnTile = null
		return
	targetTile.entityOnTile = entity.duplicate()
	targetTile.entityOnTile.OnPlace(self, coords)
	#Change entity graphic out for new

func ChangeTopper(coords:Vector2i, topperSprite:Sprite2D, additive:bool):
	pass
