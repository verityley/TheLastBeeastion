extends Entity
class_name GardenerBeeEntity

var stayInPlace:bool = false

func EntityActions(map:WorldMap, hex:Hex):
	var tile:Vector2i = hex.gridCoords
	if hex.tags["Fertile"] == true:
		var RNGTile = map.GetAdjacent(tile, RandomNumberGenerator.new().randi_range(1,6))
		var attempts:int
		if !map.hexDatabase.has(RNGTile):
			return
		while map.hexDatabase[RNGTile].tags["Fertile"] == true:
			attempts += 1
			if !map.hexDatabase.has(RNGTile):
				continue
			RNGTile = map.GetAdjacent(tile, RandomNumberGenerator.new().randi_range(1,6))
			if attempts >= 6:
				break
		map.AddRemoveTag(RNGTile, "Fertile", true)
	else:
		map.AddRemoveTag(tile, "Fertile", true)
