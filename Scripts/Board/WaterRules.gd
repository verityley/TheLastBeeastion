extends TileRuleset
class_name WaterRules

func UpdateHex(map:WorldMap, coords:Vector2i):
	var neighbors = map.GetAllAdjacent(coords)
	
	while neighbors.size() > 0:
		prints(coords, neighbors)
		var RNG = RandomNumberGenerator.new().randi_range(0, neighbors.size()-1)
		var currentTile = neighbors.pop_at(RNG)
		print("Flow: ", map.hexDatabase[currentTile].flowTile)
		if !TileTrig(map, currentTile, HexTypes.type["Water"]) and !TagTrig(map, currentTile, "Damp"):
			print("Removing non-water, non-damp tile at ", currentTile)
			continue
		if !CompareTrig(map, coords, currentTile, false):
			print("Removing equal or higher tiles at ", currentTile)
			continue
		if map.hexDatabase[coords].flowTile != null:
			if map.hexDatabase[coords].flowTile == currentTile:
				print("Removing Flow Tile")
				continue
		
		print("After: ", neighbors)
		print(currentTile)
		map.ChangeStack(coords, -1)
		map.ChangeStack(currentTile, 1)
		map.hexDatabase[currentTile].flowTile = coords
		
		map.updateOrder.erase(currentTile)
		return
	print("Loop Broke, no tile to flow to.")
	#var neighbors = map.GetAllAdjacent(coords)
	#var filteredNeighbors:Array = neighbors.duplicate()
	#if map.hexDatabase[coords].flowTile == Vector2i(0,0) and map.hexDatabase[coords].stackCount == 1:
		#return
	#print(coords, " -> Coming from ", map.hexDatabase[coords].flowTile)
	#print("Before: ", filteredNeighbors)
	#for tile in filteredNeighbors: #Narrow down to only water or damp, and only smaller unblocked stacks
		#if map.hexDatabase.has(tile):
			#if map.hexDatabase[coords].flowTile == tile:
				#print("Removing flow tile at ", tile)
				#filteredNeighbors.erase(tile)
				#continue
			#if !TileTrig(map, tile, HexTypes.type["Water"]) and !TagTrig(map, tile, "Damp"):
				#print("Removing non-water, non-damp tile at ", tile)
				#filteredNeighbors.erase(tile)
				#continue
			#if TagTrig(map, tile, "Blocked"):
				#print("Removing blocked tile at ", tile)
				#filteredNeighbors.erase(tile)
				#continue
			#if CompareTrig(map, coords, tile, true):
				#print("Removing equal or higher tiles at ", tile)
				#filteredNeighbors.erase(tile)
				#continue
			#if map.hexDatabase[coords].stackCount == map.hexDatabase[tile].stackCount:
				#print("Removing equal tiles at ", tile)
				#filteredNeighbors.erase(tile)
				#continue
		#else:
			#filteredNeighbors.erase(tile)
	#print("After: ", filteredNeighbors)
	#if filteredNeighbors.size() <= 0:
		#print("No valid tiles to flow towards.")
		#return
	#print(filteredNeighbors.size()-1)
	#print(filteredNeighbors)
	#var RNG = RandomNumberGenerator.new().randi_range(0, filteredNeighbors.size()-1)
	#var RNGtile = filteredNeighbors[RNG]
	#if map.hexDatabase.has(RNGtile):
		#print("My Stacks:", map.hexDatabase[coords].stackCount)
		#print("Target Stacks:", map.hexDatabase[RNGtile].stackCount)
		#map.ChangeStack(coords, -1)
		#map.ChangeStack(RNGtile, 1)
		#map.hexDatabase[RNGtile].flowTile = coords
		#map.updateOrder.erase(RNGtile)
		#print("Flowing towards ", RNGtile)
