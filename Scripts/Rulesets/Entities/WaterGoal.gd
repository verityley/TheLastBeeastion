extends Entity
class_name WaterGoalEntity

@export var nextGoal:Vector2i
@export var geyserPos:Vector2i
@export var stoneRing:Array[Vector2i]
@export var grownSprite:Texture2D
var grown:bool = false
var stageComplete:bool = false

func OnPlace(map:WorldMap, coords:Vector2i):
	entitySprite = Sprite2D.new()
	entityPos = coords
	map.add_child(entitySprite)
	entitySprite.texture = spriteResource
	entitySprite.position = map.to_global(map.map_to_local(coords)) + spriteOffset
	entitySprite.y_sort_enabled = true
	entitySprite.z_index = 5
	entityTags["Irreplaceable"] = true
	#map.ChangeTile(coords, HexTypes.type["Garden"], 1)
	map.AddRemoveTag(coords, "Irreplaceable", true)
	#stoneRing = map.GetHexRing(Vector2i(0,0), 5)

func EntityActions(map:WorldMap, hex:Hex):
	var coords:Vector2i = hex.gridCoords
	var neighbors = map.GetAllAdjacent(coords)
	var waterCount:int = 0
	if stageComplete == true:
		map.ChangeEntity(coords, null, true)
		map.AddRemoveTag(coords, "Irreplaceable", false)
		map.ChangeEntity(nextGoal, HexTypes.entity["Fire Goal"], true)
		map.ChangeTile(coords, HexTypes.type["Water"], 3)
	if grown == true:
		var RNG:int = RandomNumberGenerator.new().randi_range(1, 6)
		var targetTile = map.GetAdjacent(coords, RNG)
		map.ChangeTile(targetTile, HexTypes.type["Water"], 2)
		return
		
	for tile in neighbors:
		if hex.tileType.TileTrig(map, tile, HexTypes.type["Water"]):
			waterCount += 1
	if waterCount >= 6 and grown == false:
		grown = true
		map.ChangeStack(geyserPos, 1)
		for tile in neighbors:
			map.ChangeTile(tile, HexTypes.type["Water"], 3)
		
		
#Need a "ring check"
#When garden beneath reaches stack 2, increase stack of forest ring by 1, if stone, turn to forest
#grow eternal tree by 1 visual stage
#when all three are grown, removeand replace with hives
