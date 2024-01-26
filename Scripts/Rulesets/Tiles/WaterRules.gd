extends TileRuleset
class_name WaterRules

@export var floodChance:int = 2

func UpdateHex(map:WorldMap, coords:Vector2i):
	var neighbors = map.GetAllAdjacent(coords)
	
	while neighbors.size() > 0:
		#prints(coords, neighbors)
		var RNG = RandomNumberGenerator.new().randi_range(0, neighbors.size()-1)
		var RNGtile = neighbors.pop_at(RNG)
		#print("Flow: ", map.hexDatabase[currentTile].flowTile)
		if !TileTrig(map, RNGtile, HexTypes.type["Water"]) and !TagTrig(map, RNGtile, "Damp"):
		#!TagTrig(map, currentTile, "Damp"):
			#print("Removing non-water, non-damp tile at ", currentTile)
			continue
		if map.hexDatabase[coords].flowTile != null:
			if map.hexDatabase[coords].flowTile == RNGtile:
				#print("Removing Flow Tile")
				continue
		if !CompareTrig(map, coords, RNGtile, false):
			#print("Removing equal or higher tiles at ", currentTile)
			continue
		if TagTrig(map, RNGtile, "Blocked"):
			continue
		
		
		if TileTrig(map, RNGtile, HexTypes.type["Stone"]):
			map.ChangeStack(coords, -1)
			map.ChangeTile(RNGtile, HexTypes.type["Water"])
			map.updateOrder.erase(RNGtile)
			return
		elif RandomNumberGenerator.new().randi_range(0, floodChance) == floodChance and (
			!TileTrig(map, RNGtile, HexTypes.type["Water"])):
			map.ChangeStack(coords, -1)
			map.ChangeTile(RNGtile, HexTypes.type["Water"])
			map.updateOrder.erase(RNGtile)
			return
		elif TileTrig(map, RNGtile, HexTypes.type["Water"]):
			map.ChangeStack(coords, -1)
			map.ChangeStack(RNGtile, 1)
			map.hexDatabase[RNGtile].flowTile = coords
			map.updateOrder.erase(RNGtile)
			return
		
	var dampTiles = map.GetAllAdjacent(coords)
	for tile in dampTiles:
		if TagTrig(map, tile, "Damp"):
			continue
		map.AddRemoveTag(tile, "Damp", true)

func TendHex(map:WorldMap, coords:Vector2i):
	if MinMaxTrig(map, coords, false):
		map.ChangeTile(coords, HexTypes.type["Stone"], 1)
	else:
		map.ChangeStack(coords, -1)


	#print("Loop Broke, no tile to flow to.")
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
