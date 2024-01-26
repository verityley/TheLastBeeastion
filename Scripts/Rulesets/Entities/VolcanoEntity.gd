extends Entity
class_name VolcanoEntity

var finished:bool = false

func OnPlace(map:WorldMap, coords:Vector2i):
	entitySprite = Sprite2D.new()
	entityPos = coords
	map.add_child(entitySprite)
	entitySprite.texture = spriteResource
	entitySprite.position = map.to_global(map.map_to_local(coords)) + spriteOffset
	entitySprite.y_sort_enabled = true
	entitySprite.z_index = 1
	map.entityOrder.append(self)
	map.AddRemoveTag(coords, "Irreplaceable", true)


func EntityActions(map:WorldMap, hex:Hex):
	var tile:Vector2i = hex.gridCoords
	#map.updateOrder.erase(tile)
	var RNG:int = RandomNumberGenerator.new().randi_range(1, 6)
	var targetTile = map.GetAdjacent(tile, RNG)
	targetTile = map.GetAcross(tile, targetTile)
	
	if hex.stackCount >= 3 and finished == false:
		map.ChangeEntity(Vector2i(-15,7), HexTypes.entity["Rain Goal"].duplicate(), true)
		finished = true
	
	if hex.stackCount > 1:
		if hex.tileType.TileTrig(map, targetTile, HexTypes.type["Magma"]):
			if map.hexDatabase[targetTile].stackCount < hex.stackCount:
				map.ChangeStack(targetTile, 1)
			else:
				return
		elif hex.tileType.TagTrig(map, targetTile, "Flammable") or hex.tileType.TagTrig(map, targetTile, "Open"):
			map.ChangeTile(targetTile, HexTypes.type["Magma"], hex.stackCount-1)
		else:
			return
		map.hexDatabase[targetTile].flowTile = null
	else:
		var attempts:int
		while hex.tileType.TileTrig(map, targetTile, HexTypes.type["Water"]) or (
		hex.tileType.TileTrig(map, targetTile, HexTypes.type["Fire"])):
			#Reroll until not fire or water
			attempts += 1
			RNG = RandomNumberGenerator.new().randi_range(1, 6)
			targetTile = map.GetAdjacent(tile, RNG)
			if attempts > 5:
				break
		map.ChangeEntity(targetTile, HexTypes.entity["Spark"])
		var spark = map.hexDatabase[targetTile].entityOnTile
		#spark.OnPlace(map, targetTile)
		spark.sparkCount = 2
		spark.entitySprite.texture = spark.sparkResource[1]
	
