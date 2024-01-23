extends TileRuleset
class_name FireRules

@export var sparkEntity:Entity

func UpdateHex(map:WorldMap, coords:Vector2i):
	var neighbors = map.GetAllAdjacent(coords)
	var priorStack = map.hexDatabase[coords].priorStack
	
	priorStack = clampi(priorStack, 0, 3);
	if TagTrig(map, coords, "Damp"): #If tile is damp, fire starts going out.
		if MinMaxTrig(map, coords, false):
			map.ChangeTile(coords, HexTypes.type["Ash"])
		else:
			map.ChangeStack(coords, -1)
		return #Damp fires can't do any spreading or growing.
	
	
	if TimeTrig(map, coords):
		if MinMaxTrig(map, coords, true):
			map.hexDatabase[coords].outOfFuel = true
			map.ChangeStack(coords, -1)
			var RNGtile = neighbors[RandomNumberGenerator.new().randi_range(0, neighbors.size()-1)]
			if !TileTrig(map, RNGtile, HexTypes.type["Water"]) and !TileTrig(map, RNGtile, HexTypes.type["Fire"]):
				var spark = sparkEntity.duplicate()
				map.ChangeEntity(RNGtile, spark)
				spark.OnPlace(map, RNGtile)
				spark.sparkCount = priorStack
				spark.entitySprite.texture = spark.sparkResource[priorStack-1]
				#map.ChangeTile(tile, HexTypes.type["Fire"], priorStack) #Replace with Spark entity
		else:
			if map.hexDatabase[coords].outOfFuel:
				if MinMaxTrig(map, coords, false):
					var RNGtile = neighbors[RandomNumberGenerator.new().randi_range(0, neighbors.size()-1)]
					if !TileTrig(map, RNGtile, HexTypes.type["Water"]) and !TileTrig(map, RNGtile, HexTypes.type["Fire"]):
						var spark = sparkEntity.duplicate()
						map.ChangeEntity(RNGtile, spark)
						spark.OnPlace(map, RNGtile)
						spark.sparkCount = priorStack
						spark.entitySprite.texture = spark.sparkResource[priorStack-1]
					map.ChangeTile(coords, HexTypes.type["Ash"])
					map.hexDatabase[coords].outOfFuel = false
				else:
					map.ChangeStack(coords, -1)
					var RNGtile = neighbors[RandomNumberGenerator.new().randi_range(0, neighbors.size()-1)]
					if !TileTrig(map, RNGtile, HexTypes.type["Water"]) and !TileTrig(map, RNGtile, HexTypes.type["Fire"]):
						var spark = sparkEntity.duplicate()
						map.ChangeEntity(RNGtile, spark)
						spark.OnPlace(map, RNGtile)
						spark.sparkCount = priorStack
						spark.entitySprite.texture = spark.sparkResource[priorStack-1]
			else:
				map.ChangeStack(coords, 1)
			
		
		map.hexDatabase[coords].counter = self.counterStart
	else:
		map.hexDatabase[coords].counter = clampi(map.hexDatabase[coords].counter - 1, 0, self.counterStart)
