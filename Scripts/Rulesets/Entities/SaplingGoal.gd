extends Entity
class_name SaplingGoalEntity

@export var forestRing:Array[Vector2i]
@export var grownSprite:Texture2D
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
	forestRing = map.GetHexRing(Vector2i(0,0), 5)

func EntityActions(map:WorldMap, hex:Hex):
	var coords:Vector2i = hex.gridCoords
	var neighbors = map.GetAllAdjacent(coords)
	if finished == true:
		return
	if stageComplete == true:
		map.ChangeEntity(Vector2i(3,1), null, true)
		map.AddRemoveTag(Vector2i(3,1), "Irreplaceable", false)
		map.ChangeEntity(Vector2i(-3,1), null, true)
		map.AddRemoveTag(Vector2i(-3,1), "Irreplaceable", false)
		map.ChangeEntity(Vector2i(-9,4), HexTypes.entity["Geyser"], true)
		var fog = map.get_child(1)
		var tween = map.get_tree().create_tween()
		tween.tween_property(fog, "scale", Vector2(20,20), 3.0)
		await tween.finished
		fog.hide()
		finished = true
		return
	if grown == true:
		if hex.stackCount >= 4:
			entitySprite.texture = grownSprite
			stageComplete = true
			map.ChangeEntity(Vector2i(4,7), HexTypes.entity["Water Goal"].duplicate(), true)
			map.ChangeEntity(Vector2i(-5,-7), HexTypes.entity["Water Goal"].duplicate(), true)
			#map.hexDatabase[Vector2i(3,-2)].entityOnTile.stageComplete = true
			#map.hexDatabase[Vector2i(-3,-2)].entityOnTile.stageComplete = true
		return
	if hex.stackCount >= 2:
		for tile in forestRing:
			map.ChangeTile(tile, HexTypes.type["Forest"], 1)
		for tile in neighbors:
			map.ChangeTile(tile, HexTypes.type["Forest"], 1)
		grown = true
		map.ChangeEntity(Vector2i(3,1), HexTypes.entity["Forest Goal"].duplicate(), true)
		for tile in map.GetAllAdjacent(Vector2i(3,1)):
			map.ChangeTile(tile, HexTypes.type["Stone"], 1)
		map.ChangeEntity(Vector2i(-3,1), HexTypes.entity["Forest Goal"].duplicate(), true)
		for tile in map.GetAllAdjacent(Vector2i(-3,1)):
			map.ChangeTile(tile, HexTypes.type["Stone"], 1)
		map.ChangeTile(coords, HexTypes.type["Forest"], 2)
		
		
		
#Need a "ring check"
#When garden beneath reaches stack 2, increase stack of forest ring by 1, if stone, turn to forest
#grow eternal tree by 1 visual stage
#when all three are grown, removeand replace with hives
