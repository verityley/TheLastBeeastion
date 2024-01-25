extends TileRuleset
class_name WaxRules

func UpdateHex(map:WorldMap, coords:Vector2i):
	var neighbors = map.GetAllAdjacent(coords)
	var hiveCount:int = 0
	var erosionDamage:int = 0
	
	if map.hexDatabase[coords].stackCount >= 3:
		map.AddRemoveTag(coords, "Irreplaceable", true)
	
	for tile in neighbors:
		if !map.hexDatabase.has(tile):
			continue
		if TileTrig(map, tile, HexTypes.type["Wax"]):
			hiveCount += 1
			continue
		if TileTrig(map, tile, HexTypes.type["Water"]):
			if map.hexDatabase[tile].stackCount >= 3:
				erosionDamage = 1
	if EntityTrig(map, coords, "Spark"):
		erosionDamage = 3
		print("Spark on tile")
		map.remove_child(map.hexDatabase[coords].entityOnTile.entitySprite)
		map.ChangeEntity(coords, null, true)
	if erosionDamage > 0:
		map.hexDatabase[coords].counter = clampi(map.hexDatabase[coords].counter - erosionDamage, 0, self.counterStart)
		erosionDamage = 0
		if map.hexDatabase[coords].counter <= 0:
			map.ChangeTile(coords, HexTypes.type["Stone"])
	
	if EntityTrig(map, coords, "Worker"):
		if hiveCount == 6:
			map.ChangeStack(coords, 1)
			for tile in neighbors:
				if !map.hexDatabase.has(tile):
					continue
				map.ChangeTile(tile, HexTypes.type["Garden"])
				map.updateOrder.erase(tile)
		else:
			pass
	#
