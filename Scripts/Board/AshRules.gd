extends TileRuleset
class_name AshRules #Yes, she does.

func UpdateHex(map:WorldMap, coords:Vector2i):
	var neighbors = map.GetAllAdjacent(coords)
	#self.counterStart = map.hexDatabase[coords].stackCount+1
	
	#print(coords, "'s Brush Counter is at: ", map.hexDatabase[coords].counter)
	for tile in neighbors: #Try to spread to nearby fertile land every turn.
		if !map.hexDatabase.has(tile):
			continue
		if TileTrig(map, tile, typeDatabase["Water"]): #Brush spreads to fertile
			map.ChangeTile(coords, typeDatabase["Brush"])
			break
	
	if TimeTrig(map, coords):
		map.ChangeTile(coords, typeDatabase["Stone"], map.hexDatabase[coords].stackCount)
	else:
		map.hexDatabase[coords].counter = clampi(map.hexDatabase[coords].counter - 1, 0, self.counterStart)
