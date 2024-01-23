extends Entity
class_name SparkEntity

var sparkCount:int = 1
@export var sparkResource:Array[Texture2D]

func EntityActions(map:WorldMap, hex:Hex):
	var tileType:TileRuleset = hex.tileType
	var targetTile:Vector2i = map.hexDatabase[hex.gridCoords]
	if hex.tags["Damp"]:
		map.AddRemoveTag(targetTile, "Damp", false)
		map.ChangeEntity(targetTile, null, true)
		map.remove_child(entitySprite)
		map.entityOrder.erase(self)
	
	if sparkCount == 3:
		map.ChangeTile(targetTile, HexTypes.type["Fire"])
		map.ChangeEntity(targetTile, null, true)
		map.remove_child(entitySprite)
		map.entityOrder.erase(self)
		return

	if hex.tags["Flammable"]:
		sparkCount += 1
		entitySprite.texture = sparkResource[sparkCount-1]
	
	#map.entityOrder.append(self)
