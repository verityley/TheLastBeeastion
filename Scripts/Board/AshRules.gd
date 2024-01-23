extends TileRuleset
class_name AshRules #Yes, she does.

func UpdateHex(map:WorldMap, coords:Vector2i):
	var neighbors = map.GetAllAdjacent(coords)
	#self.counterStart = map.hexDatabase[coords].stackCount+1
	
	#print(coords, "'s Brush Counter is at: ", map.hexDatabase[coords].counter)
	for tile in neighbors: #Try to spread to nearby fertile land every turn.
		if !map.hexDatabase.has(tile):
			continue
		if TileTrig(map, tile, HexTypes.type["Water"]): #Brush spreads to fertile
			if MinMaxTrig(map, coords, false):
				map.ChangeTile(coords, HexTypes.type["Brush"], 1)
			else:
				map.ChangeStack(coords, -1)
			break
	
	#if TimeTrig(map, coords):
		#if MinMaxTrig(map, coords, false):
			#map.ChangeTile(coords, HexTypes.type["Stone"], 1)
			#map.hexDatabase[coords].counter = self.counterStart
		#else:
			#map.ChangeStack(coords, -1)
			#map.hexDatabase[coords].counter = self.counterStart
	#else:
		#map.hexDatabase[coords].counter = clampi(map.hexDatabase[coords].counter - 1, 0, self.counterStart)
