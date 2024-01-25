extends Entity
class_name GeyserEntity

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
	map.updateOrder.erase(tile)
	var RNG:int = RandomNumberGenerator.new().randi_range(1, 6)
	var targetTile = map.GetAdjacent(tile, RNG)
	targetTile = map.GetAcross(tile, targetTile)
	if hex.tileType.TileTrig(map, targetTile, HexTypes.type["Water"]):
		if map.hexDatabase[targetTile].stackCount < 2:
			map.ChangeStack(targetTile, 1)
		else:
			return
	elif hex.tileType.TagTrig(map, targetTile, "Damp") or hex.tileType.TagTrig(map, targetTile, "Open"):
		map.ChangeTile(targetTile, HexTypes.type["Water"], 2)
	else:
		return
	map.hexDatabase[targetTile].flowTile = null
	map.hexDatabase[targetTile].tileType.UpdateHex(map, tile)
	map.hexDatabase[targetTile].UpdateHexSprite(map)
	map.updateOrder.erase(targetTile)
	
