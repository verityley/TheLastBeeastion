extends Resource
class_name Hex

var gridCoords:Vector2i
var tileType:TileRuleset
var stackCount:int
var tags:Dictionary
var entityOnTile:Entity #Used for worker bees, specialists, or threats like sparks and enemies
var counter:int #Used for turn timers and slower growths
var topper:Sprite2D
var topperPosition:Vector2
var dampIndicator:Sprite2D
var fertileIndicator:Sprite2D
var flowTile
var priorStack:int
var outOfFuel:bool = false
var inWorkerRange:bool
var alreadyChanged:bool = false
var ring:int


func UpdateHexSprite(map:WorldMap):
	topper.texture = map.get_cell_tile_data(0, gridCoords).get_custom_data("Topper")
	#var tempColor:Color
	dampIndicator.position = map.to_global(map.map_to_local(gridCoords)) + (Vector2(0,-40+(float(stackCount-1)* -20)))
	fertileIndicator.position = map.to_global(map.map_to_local(gridCoords)) + (Vector2(0,-40+(float(stackCount-1)* -20)))
	if tags["Damp"] == true:
		dampIndicator.show()
	else:
		dampIndicator.hide()
	
	if tags["Fertile"] == true:
		fertileIndicator.show()
	else:
		fertileIndicator.hide()
	#if tags["Flammable"]:
	#	tempColor += Color(0.5, 0, 0)
	
	#topper.modulate = tempColor
	
