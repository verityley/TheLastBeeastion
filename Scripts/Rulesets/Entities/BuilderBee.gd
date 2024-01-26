extends Entity
class_name BuilderBeeEntity

var stayInPlace:bool = false

func OnPlace(map:WorldMap, coords:Vector2i):
	entitySprite = Sprite2D.new()
	entityPos = coords
	map.add_child(entitySprite)
	entitySprite.texture = spriteResource
	entitySprite.position = map.to_global(map.map_to_local(coords)) + spriteOffset
	entitySprite.y_sort_enabled = true
	entitySprite.z_index = 5
	var projectCost = map.hexDatabase[coords].tileType.CheckHoneyCost(map, coords, "Builder", stayInPlace)
	print("Projected Cost to Build: ", projectCost)

func EntityActions(map:WorldMap, hex:Hex):
	var tile:Vector2i = hex.gridCoords
	var cost = hex.tileType.CheckHoneyCost(map, tile, "Builder", stayInPlace)
	if map.honey < cost:
		map.ChangeEntity(tile, null, true)
		return
	map.honey -= cost
	stayInPlace = true
	
	if hex.tags["Open"] == true and hex.stackCount == 1:
		map.ChangeTile(tile, HexTypes.type["Wax"], 1)
		hex.alreadyChanged = true
	elif hex.tileType == HexTypes.type["Wax"]:
		hex.counter = hex.tileType.counterStart
		hex.tileType.BuildHive(map, tile)
