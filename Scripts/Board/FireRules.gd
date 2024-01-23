extends TileRuleset
class_name FireRules


func UpdateHex(map:WorldMap, coords:Vector2i):
	var neighbors = map.GetAllAdjacent(coords)
	var priorStack = map.hexDatabase[coords].priorStack
	
	priorStack = clampi(priorStack, 0, 3)
	if TagTrig(map, coords, "Damp"): #If tile is damp, fire starts going out.
		if MinMaxTrig(map, coords, false):
			map.ChangeTile(coords, HexTypes.type["Ash"])
		else:
			map.ChangeStack(coords, -1)
		return #Damp fires can't do any spreading or growing.
	
	
	if TimeTrig(map, coords):
		if MinMaxTrig(map, coords, true):
			map.ChangeTile(coords, HexTypes.type["Ash"], priorStack)
			for tile in neighbors:
				if TagTrig(map, tile, "Flammable"):
					if TagTrig(map, tile, "Damp"):
						map.AddRemoveTag(tile, "Damp", false)
					else:
						map.hexDatabase[tile].priorStack = map.hexDatabase[tile].stackCount
						map.ChangeTile(tile, HexTypes.type["Fire"], priorStack) #Replace with Spark entity
		else:
			map.ChangeStack(coords, 1)
		
		map.hexDatabase[coords].counter = self.counterStart
	else:
		map.hexDatabase[coords].counter = clampi(map.hexDatabase[coords].counter - 1, 0, self.counterStart)
