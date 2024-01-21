extends Resource
class_name Hex

var gridCoords:Vector2i
var tileType:TileRuleset
var stackCount:int
var tags:Dictionary
var entityOnTile:Entity #Used for worker bees, specialists, or threats like sparks and enemies
var counter:int #Used for turn timers and slower growths
var topper:Sprite2D
var flowTile
