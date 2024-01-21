extends TileRuleset
class_name ForestRules

func UpdateHex(map:WorldMap, coords:Vector2i):
	var neighbors = map.GetAllAdjacent(coords)
	var waterNeighbors:Array
	var forestNeighbors:Array
	
	if !TimeTrig(map, coords):
		map.hexDatabase[coords].counter = clampi(map.hexDatabase[coords].counter - 1, 0, self.counterStart)
		return
	
	for tile in neighbors: #Try to spread to nearby fertile land every turn.
		if !map.hexDatabase.has(tile):
			continue
		elif TileTrig(map, tile, HexTypes.type["Water"]): #Add nearby water to list
			waterNeighbors.append(tile)
			continue
		elif TileTrig(map, tile, HexTypes.type["Forest"]):  #Add nearby brush to list
			if map.hexDatabase[coords].stackCount > map.hexDatabase[tile].stackCount+1:
				map.ChangeStack(tile, 1) #Free water-less growth if 3:1
				map.updateOrder.erase(tile)
				map.hexDatabase[coords].counter = self.counterStart
				continue
			if !MinMaxTrig(map, tile, true):
				forestNeighbors.append(tile)
				continue
		elif TagTrig(map, tile, "Open"):  #Forest Spreads to smaller Stone
			if map.hexDatabase[coords].stackCount > map.hexDatabase[tile].stackCount+1:
				map.ChangeTile(tile, HexTypes.type["Forest"])
				map.updateOrder.erase(tile)
				map.hexDatabase[coords].counter = self.counterStart
	
	if waterNeighbors.size() <= 0: #If I couldn't get water, I'll do nothing.
		return
	if forestNeighbors.size() <= 0 and MinMaxTrig(map, coords, true): 
		return
	var waterTile = waterNeighbors[RandomNumberGenerator.new().randi_range(0, waterNeighbors.size()-1)]
	if MinMaxTrig(map, waterTile, false):
		map.ChangeTile(waterTile, HexTypes.type["Stone"])
		map.updateOrder.erase(waterTile)
	else:
		map.ChangeStack(waterTile, -1)
		map.updateOrder.erase(waterTile)
	
	if !MinMaxTrig(map, coords, true): #If I got water, I should grow!
		map.ChangeStack(coords, 1)
		return
	else: #If I got water and CAN spread, I'll grow someone else smaller than me.
		var landTile = forestNeighbors[RandomNumberGenerator.new().randi_range(0, forestNeighbors.size()-1)]
		map.ChangeStack(landTile, 1)
		map.updateOrder.erase(landTile)

#
#func UpdateHex(map:WorldMap, coords:Vector2i):
	#var neighbors = map.GetAllAdjacent(coords)
	##print(coords, "'s Forest Counter is at: ", map.hexDatabase[coords].counter)
	#if TimeTrig(map, coords): #If this hex's counter has reached zero, check neighbors for open tiles
		#var RNG = RandomNumberGenerator.new().randi_range(0, neighbors.size()-1)
		#var RNGtile = neighbors[RNG]
		#if map.hexDatabase.has(RNGtile):
			##prints(RNGtile, map.hexDatabase[RNGtile].tileType.name)
			#if TileTrig(map, RNGtile, HexTypes.type["Stone"]) and TagTrig(map, RNGtile, "Open"):
				#if CompareTrig(map, coords, RNGtile, false): #Only spread if stack is lower
					#print("Found Open Stone! Growing Grasslands")
					#map.ChangeTile(RNGtile, HexTypes.type["Brush"])
					#map.updateOrder.erase(RNGtile)
			#elif TagTrig(map, RNGtile, "Open"): #If open tile found, change tile to forest stack 1
				#if CompareTrig(map, coords, RNGtile, false): #Only spread if stack is lower
					#print("Found Open Land! Growing Saplings")
					#map.ChangeTile(RNGtile, HexTypes.type["Forest"])
					#map.updateOrder.erase(RNGtile)
			#elif TileTrig(map, RNGtile, HexTypes.type["Forest"]):
				#if CompareTrig(map, coords, RNGtile, false):
					#map.ChangeStack(RNGtile, 1)
			#elif TileTrig(map, RNGtile, HexTypes.type["Water"]):
				#if MinMaxTrig(map, RNGtile, false):
					#print("Found Shallow Water! Draining to Stone.")
					#map.ChangeTile(RNGtile, HexTypes.type["Stone"])
					#map.updateOrder.erase(RNGtile)
				#else:
					#map.ChangeStack(RNGtile, -1)
					#map.ChangeStack(coords, 1)
					#map.updateOrder.erase(RNGtile)
			#map.hexDatabase[coords].counter = self.counterStart
	#else:
		#map.hexDatabase[coords].counter = clampi(map.hexDatabase[coords].counter - 1, 0, self.counterStart)
