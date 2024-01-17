extends Resource #This means the editor allows you to make iterations of this with different variable entries
class_name HexTile #This allows other scripts to look this up as a "type", much like an Integer or String

#@export means it exposes the following variable to the editor, over on the right-->

@export var name:String #This terrain tile's name, for other scripts to check for
@export var tileIndex:Vector2i #This needs RESEARCH, figure out how to assign to tile or tiledata
@export var texture:CompressedTexture2D #This is the image for the tile, will replace with spritemap later
@export var stackCount:int #This is the current "level" of the tile, different tiles use this differently
@export var stackMax:int #The maximum this tile type can stack up to
@export var irreplacable:bool #This means that no other tile can replace this in any circumstances
@export var soundScale:Array #The array of sounds this tile makes when interacted with.
#The array above is used for randomly determined notes within a scale, to ensure audio stays in tune.

@export_category("Tile Tags") #These are tags don't do anything on their own, they're used for trigger checks by tiles
@export var tagDamp:bool 
@export var tagFlammable:bool
@export var tagFertile:bool
#Add more as needed

@export_category("Interaction Rules") #These are the fields to input triggers, and which tiles or tags fit them.
#Unsure how to organize this yet, to make sure it calls the right functions if tiles or inputs are present
#This may also be where resources are instead extended into subresources

#--adjacent trigger
#--higher than trigger
#--lower than trigger
#--tag check trigger
#--tile check trigger
#--max stack trigger
#--time trigger
#--min stacks trigger
#--worker trigger
