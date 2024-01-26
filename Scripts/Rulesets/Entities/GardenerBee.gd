extends Entity
class_name GardenerBeeEntity

var stayInPlace:bool = false

func OnPlace(map:WorldMap, coords:Vector2i):
	entitySprite = Sprite2D.new()
	entityPos = coords
	map.add_child(entitySprite)
	entitySprite.texture = spriteResource
	entitySprite.position = map.to_global(map.map_to_local(coords)) + spriteOffset
	entitySprite.y_sort_enabled = true
	entitySprite.z_index = 5
	var projectCost = map.hexDatabase[coords].tileType.CheckHoneyCost(map, coords, "Gardener", stayInPlace)
	print("Projected Cost to Fertilize: ", projectCost)

func EntityActions(map:WorldMap, hex:Hex):
	var tile:Vector2i = hex.gridCoords
	var neighbors = map.GetAllAdjacent(tile)
	var cost = hex.tileType.CheckHoneyCost(map, tile, "Gardener", stayInPlace)
	print("Cost to Fertilize: ", cost)
	if map.honey < cost:
		map.ChangeEntity(tile, null, true)
		return
	map.honey -= cost
	stayInPlace = true
	if hex.tags["Fertile"] == true:
		while neighbors.size() > 0:
			#prints(coords, neighbors)
			var RNG = RandomNumberGenerator.new().randi_range(0, neighbors.size()-1)
			var RNGtile = neighbors.pop_at(RNG)
			if !map.hexDatabase.has(RNGtile):
				continue
			if map.hexDatabase[RNGtile].tags["Fertile"] == true:
				continue
			map.AddRemoveTag(RNGtile, "Fertile", true)
			break
		
		#stayInPlace = true
	else:
		map.AddRemoveTag(tile, "Fertile", true)
		#stayInPlace = true
		
