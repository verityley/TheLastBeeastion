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
	if map.hexDatabase[coords].stackCount >= 3:
		entityTags["Irreplaceable"] = true


func EntityActions(map:WorldMap, hex:Hex):
	var workerHexes = map.GetRadiusHexes(entityPos, range)
	var neighbors = map.GetAllAdjacent(entityPos)
	for tile in neighbors:
		if map.hexDatabase[tile].tileType != HexTypes.type["Garden"]:
			map.ChangeTile(tile, HexTypes.type["Garden"])
			map.hexDatabase[tile].tileType.UpdateHex(map, tile)
	for tile in workerHexes:
		map.hexDatabase[tile].inWorkerRange = true
	
