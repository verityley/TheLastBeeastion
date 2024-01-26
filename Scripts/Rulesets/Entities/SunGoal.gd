extends Entity
class_name SunGoalEntity

@export var stoneRing:Array[Vector2i]
@export var volcanoPos:Vector2i
var grown:bool = false
var stageComplete:bool = false
var finished:bool = false

func OnPlace(map:WorldMap, coords:Vector2i):
	entitySprite = Sprite2D.new()
	entityPos = coords
	map.add_child(entitySprite)
	entitySprite.texture = spriteResource
	entitySprite.position = map.to_global(map.map_to_local(coords)) + spriteOffset
	entitySprite.y_sort_enabled = true
	entitySprite.z_index = 5
	entityTags["Irreplaceable"] = true
	map.ChangeTile(coords, HexTypes.type["Garden"], 1)
	map.AddRemoveTag(coords, "Irreplaceable", true)
	#stoneRing = map.GetHexRing(Vector2i(0,0), 12)

func EntityActions(map:WorldMap, hex:Hex):
	var coords:Vector2i = hex.gridCoords
	var neighbors = map.GetAllAdjacent(coords)
	if stageComplete == true:
		map.AddRemoveTag(coords, "Irreplaceable", false)
		map.ChangeEntity(Vector2i(4,7), null, true)
		map.AddRemoveTag(Vector2i(4,7), "Irreplaceable", false)
		map.ChangeEntity(Vector2i(-5,-7), null, true)
		map.AddRemoveTag(Vector2i(-5,-7), "Irreplaceable", false)
		map.ChangeEntity(coords, null, true)
		return
	if grown == true:
		return
	if hex.stackCount >= 3 and grown == false:
		grown = true
		map.ChangeStack(volcanoPos, 1)
		for tile in neighbors:
			map.ChangeTile(tile, HexTypes.type["Magma"], 2)
#Need a "ring check"
#When garden beneath reaches stack 2, increase stack of forest ring by 1, if stone, turn to forest
#grow eternal tree by 1 visual stage
#when all three are grown, removeand replace with hives
