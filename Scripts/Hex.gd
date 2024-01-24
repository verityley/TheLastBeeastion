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
var flowTile
var priorStack:int
var outOfFuel:bool = false


func UpdateHexSprite(map:WorldMap):
	topper.texture = map.get_cell_tile_data(0, gridCoords).get_custom_data("Topper")
	#var tempColor:Color
	#if tags["Damp"]:
		#tempColor += Color(0, 0, 0.5)
	#if tags["Fertile"]:
		#tempColor += Color(0, 0.5, 0)
	#if tags["Flammable"]:
	#	tempColor += Color(0.5, 0, 0)
	
	#topper.modulate = tempColor
	
