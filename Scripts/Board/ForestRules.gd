extends TileRuleset
class_name ForestRules

func UpdateHex(map:WorldMap, coords:Vector2i):
	var neighbors = map.GetAllAdjacent(coords)
	#print(coords, "'s Forest Counter is at: ", map.hexDatabase[coords].counter)
	if TimeTrig(map, coords): #If this hex's counter has reached zero, check neighbors for open tiles
		var RNG = RandomNumberGenerator.new().randi_range(0, neighbors.size()-1)
		var RNGtile = neighbors[RNG]
		if map.hexDatabase.has(RNGtile):
			#prints(RNGtile, map.hexDatabase[RNGtile].tileType.name)
			if TileTrig(map, RNGtile, HexTypes.type["Stone"]) and TagTrig(map, RNGtile, "Open"):
				if CompareTrig(map, coords, RNGtile, false): #Only spread if stack is lower
					print("Found Open Stone! Growing Grasslands")
					map.ChangeTile(RNGtile, HexTypes.type["Brush"])
					map.updateOrder.erase(RNGtile)
			elif TagTrig(map, RNGtile, "Open"): #If open tile found, change tile to forest stack 1
				if CompareTrig(map, coords, RNGtile, false): #Only spread if stack is lower
					print("Found Open Land! Growing Saplings")
					map.ChangeTile(RNGtile, HexTypes.type["Forest"])
					map.updateOrder.erase(RNGtile)
			elif TileTrig(map, RNGtile, HexTypes.type["Forest"]):
				map.ChangeStack(RNGtile, 1)
			map.hexDatabase[coords].counter = self.counterStart
	else:
		map.hexDatabase[coords].counter = clampi(map.hexDatabase[coords].counter - 1, 0, self.counterStart)
