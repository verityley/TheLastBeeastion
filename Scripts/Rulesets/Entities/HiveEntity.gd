extends Entity
class_name Hive

@export var range:int = 5

func OnPlace(map:WorldMap, coords:Vector2i):
	entitySprite = Sprite2D.new()
	entityPos = coords
	map.add_child(entitySprite)
	entitySprite.texture = spriteResource
	entitySprite.position = map.to_global(map.map_to_local(coords)) + spriteOffset
	entitySprite.y_sort_enabled = true
	entitySprite.z_index = 1
	map.entityOrder.append(self)
	var workerHexes = map.GetRadiusHexes(entityPos, range)
	var neighbors = map.GetAllAdjacent(entityPos)
	for tile in neighbors:
		if map.hexDatabase[tile].tileType != HexTypes.type["Garden"]:
			if map.hexDatabase[tile].entityOnTile != null:
				if map.hexDatabase[tile].entityOnTile.name == "Hive":
					continue
			map.ChangeTile(tile, HexTypes.type["Garden"])
			#map.AddRemoveTag(tile, "Open", false)
			#map.hexDatabase[tile].tileType.UpdateHex(map, tile)
	for tile in workerHexes:
		map.hexDatabase[tile].inWorkerRange = true
	if map.hexDatabase[coords].stackCount >= 3:
		entityTags["Irreplaceable"] = true
		map.AddRemoveTag(coords, "Irreplaceable", true)
		#map.availableWorkers += 2
		#map.workerMax += 2
	else:
		map.availableWorkers += 1
		map.workerMax += 1

func EntityActions(map:WorldMap, hex:Hex):
	var workerHexes = map.GetRadiusHexes(entityPos, range)
	var neighbors = map.GetAllAdjacent(entityPos)
	if map.hexDatabase[entityPos].stackCount < 3:
		return
	for tile in neighbors:
		if map.hexDatabase[tile].tileType != HexTypes.type["Garden"]:
			map.ChangeTile(tile, HexTypes.type["Garden"])
			map.AddRemoveTag(tile, "Open", false)
			
	
