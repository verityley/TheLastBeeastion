extends TileRuleset
class_name ForestRules

func UpdateHex(map:WorldMap, coords:Vector2i):
	var neighbors = map.GetAllAdjacent(coords)
	print(map.hexDatabase[coords].counter)
	if TimeTrig(map, coords): #If this hex's counter has reached zero, check neighbors for open tiles
		var RNG = RandomNumberGenerator.new().randi_range(0, neighbors.size()-1)
		var tile = neighbors[RNG]
		if map.hexDatabase.has(tile):
			prints(tile, map.hexDatabase[tile].tileType.name)
			if TagTrig(map, tile, "Open"): #If open tile found, change tile to forest stack 1
				print("Found Open Land! Growing Saplings")
				map.ChangeTile(tile, self)
				map.updateOrder.erase(tile)
			map.hexDatabase[coords].counter = self.counterStart
	map.hexDatabase[coords].counter = clampi(map.hexDatabase[coords].counter - 1, 0, self.counterStart)
