extends TileRuleset
class_name GardenRules

func UpdateHex(map:WorldMap, coords:Vector2i):
	#var neighbors = map.GetAllAdjacent(coords)
	##print("Starting Garden Spread")
	#for tile in neighbors:
		#if !map.hexDatabase.has(tile):
			#continue
		##prints(tile, map.hexDatabase[tile].tileType.name)
		#if TagTrig(map, tile, "Fertile"):
			##print("Found Fertile Land!")
			#map.ChangeTile(tile, self)
			#map.updateOrder.erase(tile)
	
	var neighbors = map.GetAllAdjacent(coords)
	#print(coords, "'s Forest Counter is at: ", map.hexDatabase[coords].counter)
	var RNG:int
	var RNGtile:Vector2i
	#For each stack of garden tile, propogate once. If propogates into garden, increase stack of target.
	for i in range(map.hexDatabase[coords].stackCount):
		RNG = RandomNumberGenerator.new().randi_range(0, neighbors.size()-1)
		RNGtile = neighbors[RNG]
		if map.hexDatabase.has(RNGtile):
			#prints(tile, map.hexDatabase[tile].tileType.name)
			if TagTrig(map, RNGtile, "Fertile"): #If fertile tile found, change tile to garden stack 1
				#print("Found Fertile Land! Growing Garden.")
				map.ChangeTile(RNGtile, self)
				map.updateOrder.erase(RNGtile)
			elif TileTrig(map, RNGtile, self):
				print("Found Garden Tile, growing stacks on target.")
				map.ChangeStack(RNGtile, 1)
	
	
	pass #For subresource, list all possible trigger/effect combos as ordered if statements
	#if triggerX(map, coords) == true:
	#	doEventY(tiletype)
