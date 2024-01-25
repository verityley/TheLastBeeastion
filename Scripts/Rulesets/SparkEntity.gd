extends Entity
class_name SparkEntity

var sparkCount:int = 1
@export var sparkResource:Array[Texture2D]

func EntityActions(map:WorldMap, hex:Hex):
	var tileType:TileRuleset = hex.tileType
	var tile:Vector2i = hex.gridCoords
	sparkCount = clampi(sparkCount, 1, 4)
	#map.updateOrder.erase(tile)
	if hex.tags["Damp"] == true:
		map.AddRemoveTag(tile, "Damp", false)
		map.ChangeEntity(tile, null, true)
		map.remove_child(entitySprite)
		return
		#map.entityOrder.erase(self)
	
	if hex.tags["Flammable"] == true:
		sparkCount += 1
		if sparkCount == 4:
			map.hexDatabase[tile].priorStack = clampi(map.hexDatabase[tile].stackCount, 0, 3)
			map.ChangeTile(tile, HexTypes.type["Fire"])
			map.ChangeEntity(tile, null, true)
			map.remove_child(entitySprite)
			map.entityOrder.erase(self)
			return
		entitySprite.texture = sparkResource[sparkCount-1]
	else:
		sparkCount -= 1
		if sparkCount <= 0:
			map.ChangeEntity(tile, null, true)
			map.remove_child(entitySprite)
			map.entityOrder.erase(self)
		entitySprite.texture = sparkResource[sparkCount-1]
	#map.hexDatabase[tile].tileType.UpdateHex(map, tile)
	#map.entityOrder.append(self)
