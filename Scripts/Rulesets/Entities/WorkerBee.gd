extends Entity
class_name WorkerBeeEntity

var stayInPlace:bool = false

func EntityActions(map:WorldMap, hex:Hex):
	var tile:Vector2i = hex.gridCoords
	map.hexDatabase[tile].tileType.TendHex(map, tile)
	map.hexDatabase[tile].alreadyChanged = true
