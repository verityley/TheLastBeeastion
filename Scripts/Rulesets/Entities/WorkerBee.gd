extends Entity
class_name WorkerBeeEntity

var stayInPlace:bool = false

func OnPlace(map:WorldMap, coords:Vector2i):
	entitySprite = Sprite2D.new()
	entityPos = coords
	map.add_child(entitySprite)
	entitySprite.texture = spriteResource
	entitySprite.position = map.to_global(map.map_to_local(coords)) + spriteOffset
	entitySprite.y_sort_enabled = true
	entitySprite.z_index = 5
	var projectCost = map.hexDatabase[coords].tileType.CheckHoneyCost(map, coords, "Worker", stayInPlace)
	print("Projected Cost to Work: ", projectCost)

func EntityActions(map:WorldMap, hex:Hex):
	var tile:Vector2i = hex.gridCoords
	var cost = hex.tileType.CheckHoneyCost(map, tile, "Worker", stayInPlace)
	if map.honey < cost:
		map.ChangeEntity(tile, null, true)
		return
	map.honey -= cost
	stayInPlace = true
	
	map.hexDatabase[tile].tileType.TendHex(map, tile)
	map.hexDatabase[tile].alreadyChanged = true
	#stayInPlace = true
