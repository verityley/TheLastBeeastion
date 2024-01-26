extends Entity
class_name GardenerBeeEntity

var stayInPlace:bool = false

func EntityActions(map:WorldMap, hex:Hex):
	var tile:Vector2i = hex.gridCoords
	if hex.tags["Fertile"] == true:
		var RNGTile = map.GetAdjacent(tile, RandomNumberGenerator.new().randi_range(1,6))
		map.AddRemoveTag(RNGTile, "Fertile", true)
	else:
		map.AddRemoveTag(tile, "Fertile", true)
