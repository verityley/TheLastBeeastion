extends TileRuleset
class_name BrushRules

func UpdateHex(map:WorldMap, coords:Vector2i):
	var neighbors = map.GetAllAdjacent(coords)
	var waterNeighbors:Array
	var brushNeighbors:Array
	
	for tile in neighbors: #Try to spread to nearby fertile land every turn.
		if !map.hexDatabase.has(tile):
			continue
		elif TileTrig(map, tile, HexTypes.type["Water"]): #Add nearby water to list
			waterNeighbors.append(tile)
			continue
		elif TileTrig(map, tile, HexTypes.type["Brush"]):  #Add nearby brush to list
			if map.hexDatabase[coords].stackCount > map.hexDatabase[tile].stackCount+1:
				map.ChangeStack(tile, 1) #Free water-less growth if 3:1
				map.updateOrder.erase(tile)
				continue
			elif !MinMaxTrig(map, tile, true):
				brushNeighbors.append(tile)
				continue
		if TagTrig(map, tile, "Fertile"): #Brush spreads to fertile
			if CompareTrig(map, coords, tile, false): #Only if stack is lower
				#print("Found Fertile Land!")
				map.ChangeTile(tile, HexTypes.type["Brush"])
				map.updateOrder.erase(tile)
	
	if waterNeighbors.size() <= 0: #If I couldn't get water, I'll do nothing.
		return
	var waterTile = waterNeighbors[RandomNumberGenerator.new().randi_range(0, waterNeighbors.size()-1)]
	if MinMaxTrig(map, waterTile, false):
		map.ChangeTile(waterTile, HexTypes.type["Stone"])
		map.updateOrder.erase(waterTile)
	else:
		map.ChangeStack(waterTile, -1)
		map.updateOrder.erase(waterTile)
	
	if brushNeighbors.size() <= 0: #If I got water and can't spread, I should grow!
		if MinMaxTrig(map, coords, true):
			map.ChangeTile(coords, HexTypes.type["Forest"], 1)
		else:
			map.ChangeStack(coords, 1)
		return
	var landTile = brushNeighbors[RandomNumberGenerator.new().randi_range(0, brushNeighbors.size()-1)]
	#If I got water and CAN spread, I'll grow someone else smaller than me.
	map.ChangeStack(landTile, 1)
	map.updateOrder.erase(landTile)
	
	
	#if TimeTrig(map, coords):
		#if MinMaxTrig(map, coords, true):
			#for tile in neighbors:
				#if !map.hexDatabase.has(tile):
					#continue
				#if TileTrig(map, tile, HexTypes.type["Water"]):
					#map.ChangeTile(coords, HexTypes.type["Forest"], 1)
					#map.ChangeTile(tile, HexTypes.type["Stone"], 1)
					#map.updateOrder.erase(tile)
					#break
		#else:
			#map.ChangeStack(coords, 1)
			##print("Stacks are at: ", map.hexDatabase[coords].stackCount)
			#map.hexDatabase[coords].counter = self.counterStart
	#else:
		#map.hexDatabase[coords].counter = clampi(map.hexDatabase[coords].counter - 1, 0, self.counterStart)
