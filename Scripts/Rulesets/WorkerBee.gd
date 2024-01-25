extends Entity
class_name WorkerBeeEntity

var stayInPlace:bool = false

func EntityActions(map:WorldMap, hex:Hex):
	var tile:Vector2i = hex.gridCoords
	map.updateOrder.erase(tile)
	map.hexDatabase[tile].tileType.UpdateHex(map, tile)
	if stayInPlace == false:
		map.ChangeEntity(tile, null, true)
		map.remove_child(entitySprite)
		map.entityOrder.erase(self)
