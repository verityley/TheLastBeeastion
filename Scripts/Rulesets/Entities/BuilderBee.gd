extends Entity
class_name BuilderBeeEntity

var stayInPlace:bool = false

func EntityActions(map:WorldMap, hex:Hex):
	var tile:Vector2i = hex.gridCoords
	if hex.tags["Open"] == true:
		map.ChangeTile(tile, HexTypes.type["Wax"], 1)
		hex.alreadyChanged = true
	elif hex.tileType == HexTypes.type["Wax"]:
		hex.counter = hex.tileType.counterStart
		hex.tileType.BuildHive(map, tile)
