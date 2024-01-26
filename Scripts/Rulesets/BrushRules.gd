extends TileRuleset
class_name BrushRules

func UpdateHex(map:WorldMap, coords:Vector2i):
	var neighbors = map.GetAllAdjacent(coords)
	var waterNeighbors:Array
	var brushNeighbors:Array
	for tile in neighbors:
		if !map.hexDatabase.has(tile):
			continue
		if TileTrig(map, tile, HexTypes.type["Water"]): #Add nearby water to list
			waterNeighbors.append(tile)
			continue
		if TileTrig(map, tile, HexTypes.type["Brush"]):
			if map.hexDatabase[coords].stackCount > map.hexDatabase[tile].stackCount+1:
				map.ChangeStack(tile, 1)
				map.updateOrder.erase(tile)
				continue
		if TagTrig(map, tile, "Open"):
			if TagTrig(map, tile, "Fertile"): #Brush spreads to fertile
				if !CompareTrig(map, coords, tile, true): #Only if stack isnt higher
					map.ChangeTile(tile, HexTypes.type["Brush"])
					map.updateOrder.erase(tile)
					continue
			elif map.hexDatabase[coords].stackCount > map.hexDatabase[tile].stackCount+1:
				map.ChangeTile(tile, HexTypes.type["Brush"])
				map.updateOrder.erase(tile)
				continue
		
	
	#If not at max, increase stack if damp or fertile.
	if !MinMaxTrig(map, coords, true):
		if TagTrig(map, coords, "Damp"):
			map.ChangeStack(coords, 1)
		return
	#Don't go further if no water to spend, or if not at max stacks.
	if waterNeighbors.size() <= 0: #If I couldn't get water, I'll do nothing.
		return
	#Check random neighboring water tile, decrease stack or change to stone if empty.
	var waterTile = waterNeighbors[RandomNumberGenerator.new().randi_range(0, waterNeighbors.size()-1)]
	if MinMaxTrig(map, waterTile, false):
		map.ChangeTile(waterTile, HexTypes.type["Stone"])
		map.AddRemoveTag(waterTile, "Damp", true)
		map.hexDatabase[waterTile].flowTile = null
		map.updateOrder.erase(waterTile)
	else:
		map.ChangeStack(waterTile, -1)
		map.updateOrder.erase(waterTile)
	#After spending water, grow to forest.
	map.ChangeTile(coords, HexTypes.type["Forest"], 1)
	

func TendHex(map:WorldMap, coords:Vector2i):
	map.ChangeStack(coords, -2)

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
