extends Entity
class_name TreeFlowerEntity

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
	map.AddRemoveTag(coords, "Irreplaceable", true)
	forestRing = map.GetHexRing(Vector2i(0,0), 5)

func EntityActions(map:WorldMap, hex:Hex):
	var tile:Vector2i = hex.gridCoords
	if stageComplete == true:
		map.ChangeEntity(tile, null, true)
	if grown == true:
		return
	if hex.stackCount >= 2:
		for ringtile in forestRing:
			if map.hexDatabase[ringtile].tileType.name == "Stone":
				map.ChangeTile(ringtile, HexTypes.type["Forest"], 1)
			else:
				map.ChangeStack(ringtile, 1)
		grown = true
#Need a "ring check"
#When garden beneath reaches stack 2, increase stack of forest ring by 1, if stone, turn to forest
#grow eternal tree by 1 visual stage
#when all three are grown, removeand replace with hives
