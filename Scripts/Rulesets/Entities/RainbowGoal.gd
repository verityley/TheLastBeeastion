extends Entity
class_name RainGoalEntity

@export var nextGoal:Vector2i
@export var stoneRing:Array[Vector2i]
@export var grownSprites:Array[Texture2D]
var growthStage:int = 7
var targetType:TileRuleset
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
	map.ChangeTile(coords, HexTypes.type["Stone"], 1)
	map.AddRemoveTag(coords, "Irreplaceable", true)
	targetType = HexTypes.type["Stone"]
	#stoneRing = map.GetHexRing(Vector2i(0,0), 5)

func EntityActions(map:WorldMap, hex:Hex):
	var coords:Vector2i = hex.gridCoords
	var neighbors = map.GetAllAdjacent(coords)
	var correctCount:int = 0
	if stageComplete == true:
		#Victory Screen
		pass
	
	map.ChangeTile(coords, targetType, 1)
	map.AddRemoveTag(coords, "Irreplaceable", true)
	
	if growthStage == 7:
		var allHexes = map.GetAllHexes(20)
		for tile in allHexes:
			if map.hexDatabase.has(tile):
				map.AddRemoveTag(tile, "Damp", true)
				map.AddRemoveTag(tile, "Fertile", true)
	
	#if growthStage == 1:
		#targetType = HexTypes.type["Stone"]
	#elif growthStage == 2:
		#targetType = HexTypes.type["Water"]
	#elif growthStage == 3:
		#targetType = HexTypes.type["Brush"]
	#elif growthStage == 4:
		#targetType = HexTypes.type["Forest"]
	#elif growthStage == 5:
		#targetType = HexTypes.type["Garden"]
	#elif growthStage == 6:
		#targetType = HexTypes.type["Hive"]
	#elif growthStage == 7:
		#pass #Win the Game!
		#Brush
		#Forest
		#Garden
		#Hive
		
	for tile in neighbors:
		if hex.tileType.TileTrig(map, tile, targetType):
			correctCount += 1
		print(correctCount)
	if correctCount >= 6:
		growthStage += 1
		if growthStage == 1:
			targetType = HexTypes.type["Stone"]
		elif growthStage == 2:
			targetType = HexTypes.type["Water"]
		elif growthStage == 3:
			targetType = HexTypes.type["Brush"]
		elif growthStage == 4:
			targetType = HexTypes.type["Forest"]
		elif growthStage == 5:
			targetType = HexTypes.type["Garden"]
		elif growthStage == 6:
			targetType = HexTypes.type["Hive"]
		elif growthStage == 7:
			pass #Win the Game!
		map.AddRemoveTag(coords, "Irreplaceable", false)
		map.ChangeTile(coords, targetType, 1)
		map.AddRemoveTag(coords, "Irreplaceable", true)
		for tile in neighbors:
			map.ChangeTile(tile, HexTypes.type["Stone"], 1)
		
		
#Need a "ring check"
#When garden beneath reaches stack 2, increase stack of forest ring by 1, if stone, turn to forest
#grow eternal tree by 1 visual stage
#when all three are grown, removeand replace with hives
