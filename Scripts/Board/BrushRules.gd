extends TileRuleset
class_name BrushRules

func UpdateHex(map:WorldMap, coords:Vector2i):
	var neighbors = map.GetAllAdjacent(coords)
	#self.counterStart = map.hexDatabase[coords].stackCount+1
	
	#print(coords, "'s Brush Counter is at: ", map.hexDatabase[coords].counter)
	for tile in neighbors: #Try to spread to nearby fertile land every turn.
		if !map.hexDatabase.has(tile):
			continue
		if TagTrig(map, tile, "Fertile"): #Brush spreads to fertile
			if CompareTrig(map, coords, tile, false): #Only if stack is lower
				#print("Found Fertile Land!")
				map.ChangeTile(tile, HexTypes.type["Brush"])
				map.updateOrder.erase(tile)
	
	if TimeTrig(map, coords):
		if MinMaxTrig(map, coords, true):
			for tile in neighbors:
				if !map.hexDatabase.has(tile):
					continue
				if TileTrig(map, tile, HexTypes.type["Water"]):
					map.ChangeTile(coords, HexTypes.type["Forest"], 1)
					map.ChangeTile(tile, HexTypes.type["Stone"], 1)
					map.updateOrder.erase(tile)
		else:
			map.ChangeStack(coords, 1)
			#print("Stacks are at: ", map.hexDatabase[coords].stackCount)
			map.hexDatabase[coords].counter = self.counterStart
	else:
		map.hexDatabase[coords].counter = clampi(map.hexDatabase[coords].counter - 1, 0, self.counterStart)
