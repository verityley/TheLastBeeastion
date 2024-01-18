extends TileRuleset
class_name GardenRules

@export var emptyRules:TileRuleset

func UpdateHex(map:WorldMap, coords:Vector2i):
	var neighbors = map.GetAllAdjacent(coords)
	#print("Starting Garden Spread")
	for tile in neighbors:
		if !map.hexDatabase.has(tile):
			continue
		#prints(tile, map.hexDatabase[tile].tileType.name)
		if TileTrig(map, tile, emptyRules) or TagTrig(map, tile, "Fertile"):
			#print("Found Fertile Land!")
			map.ChangeTile(tile, self)
			map.updateOrder.erase(tile)
	
	pass #For subresource, list all possible trigger/effect combos as ordered if statements
	#if triggerX(map, coords) == true:
	#	doEventY(tiletype)
