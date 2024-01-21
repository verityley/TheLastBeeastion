extends TileRuleset
class_name BrushRules

@export var forestRuleset:TileRuleset

func UpdateHex(map:WorldMap, coords:Vector2i):
	var neighbors = map.GetAllAdjacent(coords)
	self.counterStart = map.hexDatabase[coords].stackCount+1
	
	#print(coords, "'s Brush Counter is at: ", map.hexDatabase[coords].counter)
	for tile in neighbors: #Try to spread to nearby fertile land every turn.
		if !map.hexDatabase.has(tile):
			continue
		if TagTrig(map, tile, "Fertile"): #Brush spreads to fertile
			if CompareTrig(map, coords, tile, false): #Only if stack is lower
				#print("Found Fertile Land!")
				map.ChangeTile(tile, self)
				map.updateOrder.erase(tile)
	
	if TimeTrig(map, coords):
		if MinMaxTrig(map, coords, true):
			if TagTrig(map, coords, "Damp"):
				map.ChangeTile(coords, forestRuleset, 1, false)
		else:
			map.ChangeStack(coords, 1)
			#print("Stacks are at: ", map.hexDatabase[coords].stackCount)
			map.hexDatabase[coords].counter = self.counterStart+1
	else:
		map.hexDatabase[coords].counter = clampi(map.hexDatabase[coords].counter - 1, 0, self.counterStart)
