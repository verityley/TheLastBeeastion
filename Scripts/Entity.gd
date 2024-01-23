extends Resource
class_name Entity

@export var name:String
@export var spriteResource:CompressedTexture2D
var entityTags:Dictionary
var entityPos:Vector2i
var entitySprite:Sprite2D

func OnPlace(map:WorldMap, coords:Vector2i):
	entitySprite = Sprite2D.new()
	entityPos = coords
	map.add_child(entitySprite)
	entitySprite.texture = spriteResource
	entitySprite.position = map.to_global(map.map_to_local(coords))
	entitySprite.y_sort_enabled = true
	entitySprite.z_index = 1
	map.entityOrder.append(self)

func UpdateEntity(map:WorldMap):
	var occupiedTile:Hex = map.hexDatabase[entityPos]
	map.updateOrder.append(entityPos)
	EntityActions(map, occupiedTile)

func EntityActions(map:WorldMap, hex:Hex):
	pass
	#Add individual entity rules here