extends TileRuleset
class_name GardenRules

func UpdateHex(map:WorldMap, coords:Vector2i):
	var neighbors = map.GetAllAdjacent(coords)
	var smallestGarden:int = 0
	var gardenCount:int = 0
	for tile in neighbors:
		if !map.hexDatabase.has(tile):
			continue
		if TileTrig(map, tile, HexTypes.type["Garden"]):
			gardenCount += 1
			if smallestGarden == 0:
				smallestGarden = map.hexDatabase[tile].stackCount
			else:
				smallestGarden = mini(smallestGarden, map.hexDatabase[tile].stackCount)
		if TagTrig(map, tile, "Fertile") and TagTrig(map, tile, "Open"): #Brush spreads to fertile
			if !CompareTrig(map, coords, tile, true): #Only if stack is lower
				map.ChangeTile(tile, HexTypes.type["Garden"])
				map.updateOrder.erase(tile)
				continue
	if gardenCount == 6:
		#print("Smallest Garden is ", smallestGarden)
		if map.hexDatabase[coords].stackCount <= smallestGarden:
			map.ChangeStack(coords, 1)
		
	
	#Increase Honey Resource by Stack Count
