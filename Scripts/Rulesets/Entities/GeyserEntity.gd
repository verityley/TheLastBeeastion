extends Entity
class_name GeyserEntity

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
	if hex.stackCount >= 3 and finished == false:
		map.ChangeEntity(Vector2i(9,-5), HexTypes.entity["Fire Goal"].duplicate(), true)
		finished = true
	
	var RNG:int = RandomNumberGenerator.new().randi_range(1, 6)
	var targetTile = map.GetAdjacent(tile, RNG)
	targetTile = map.GetAcross(tile, targetTile)
	if hex.tileType.TileTrig(map, targetTile, HexTypes.type["Water"]):
		if map.hexDatabase[targetTile].stackCount < hex.stackCount or hex.stackCount == 1:
			map.ChangeStack(targetTile, 1)
		else:
			return
	elif hex.tileType.TagTrig(map, targetTile, "Damp") or hex.tileType.TagTrig(map, targetTile, "Open"):
		map.ChangeTile(targetTile, HexTypes.type["Water"], hex.stackCount)
	else:
		return
	map.hexDatabase[targetTile].flowTile = null
	#map.hexDatabase[targetTile].tileType.UpdateHex(map, tile)
	#map.hexDatabase[targetTile].UpdateHexSprite(map)
	#map.updateOrder.erase(targetTile)
	
