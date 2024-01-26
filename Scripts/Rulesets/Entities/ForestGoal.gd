extends Entity
class_name ForestGoalEntity

@export var forestRing:Array[Vector2i]
@export var eternalTree:Vector2i
var grown:bool = false
var stageComplete:bool = false

func OnPlace(map:WorldMap, coords:Vector2i):
	entitySprite = Sprite2D.new()
	entityPos = coords
	map.add_child(entitySprite)
	entitySprite.texture = spriteResource
	entitySprite.position = map.to_global(map.map_to_local(coords)) + spriteOffset
	entitySprite.y_sort_enabled = true
	entitySprite.z_index = 1
	entityTags["Irreplaceable"] = true
	map.ChangeTile(coords, HexTypes.type["Garden"], 1)
	map.AddRemoveTag(coords, "Irreplaceable", true)
	forestRing = map.GetHexRing(Vector2i(0,0), 5)

func EntityActions(map:WorldMap, hex:Hex):
	var coords:Vector2i = hex.gridCoords
	var neighbors = map.GetAllAdjacent(coords)
	if stageComplete == true:
		map.AddRemoveTag(coords, "Irreplaceable", false)
		map.ChangeEntity(coords, null, true)
	if grown == true:
		return
	if hex.stackCount >= 2:
		for tile in forestRing:
			if map.hexDatabase[tile].tileType.name != "Forest":
				map.ChangeTile(tile, HexTypes.type["Forest"], 1)
			map.ChangeStack(tile, 1)
		for tile in neighbors:
			map.ChangeTile(tile, HexTypes.type["Brush"], 2)
		grown = true
		map.ChangeTile(coords, HexTypes.type["Brush"], 3)
		map.ChangeStack(Vector2i(0,-3), 1)
#Need a "ring check"
#When garden beneath reaches stack 2, increase stack of forest ring by 1, if stone, turn to forest
#grow eternal tree by 1 visual stage
#when all three are grown, removeand replace with hives
