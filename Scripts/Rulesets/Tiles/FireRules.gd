extends TileRuleset
class_name FireRules

func UpdateHex(map:WorldMap, coords:Vector2i):
	var neighbors = map.GetAllAdjacent(coords)
	var priorStack = map.hexDatabase[coords].priorStack
	priorStack = clampi(priorStack, 0, 3);
	
	if TagTrig(map, coords, "Damp"): #If tile is damp, fire starts going out.
		if MinMaxTrig(map, coords, false):
			map.ChangeTile(coords, HexTypes.type["Ash"], priorStack)
		else:
			map.ChangeStack(coords, -1)
		return #Damp fires can't do any spreading or growing.
	
	if !TimeTrig(map, coords):
		map.hexDatabase[coords].counter = clampi(map.hexDatabase[coords].counter - 1, 0, self.counterStart)
		return
	else:
		map.hexDatabase[coords].counter = self.counterStart
	
	if map.hexDatabase[coords].outOfFuel:
		var RNGtile = neighbors[RandomNumberGenerator.new().randi_range(0, neighbors.size()-1)]
		var attempts:int
		while TileTrig(map, RNGtile, HexTypes.type["Water"]) or (
		TileTrig(map, RNGtile, HexTypes.type["Fire"]) or
		TileTrig(map, RNGtile, HexTypes.type["Magma"])):
			#Reroll until not fire or water
			attempts += 1
			RNGtile = neighbors[RandomNumberGenerator.new().randi_range(0, neighbors.size()-1)]
			if attempts > 5:
				break
		map.ChangeEntity(RNGtile, HexTypes.entity["Spark"])
		if map.hexDatabase[RNGtile].entityOnTile.name == "Spark":
			var spark = map.hexDatabase[RNGtile].entityOnTile
			spark.sparkCount = priorStack
			spark.entitySprite.texture = spark.sparkResource[priorStack-1]
		if MinMaxTrig(map, coords, false):
			map.ChangeTile(coords, HexTypes.type["Ash"], priorStack)
		else:
			map.ChangeStack(coords, -1)
		return
	
	if map.hexDatabase[coords].stackCount >= priorStack:
		map.hexDatabase[coords].outOfFuel = true
		return
	else:
		map.ChangeStack(coords, 1)

func TendHex(map:WorldMap, coords:Vector2i):
	map.AddRemoveTag(coords, "Damp", true)
