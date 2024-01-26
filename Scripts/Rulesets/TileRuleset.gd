extends Resource #This means the editor allows you to make iterations of this with different variable entries
class_name TileRuleset #This allows other scripts to look this up as a "type", much like an Integer or String

#@export means it exposes the following variable to the editor, over on the right-->
@export var name:String #This terrain tile's name, for other scripts to check for
@export var tileIndex:Vector2i #This is the Atlas coordinate pair tied to the TileSet
@export var stackMax:int #The maximum this tile type can stack up to
@export var counterStart:int #This is what the hex's counter begins at when tile placed
@export var soundScale:Array #The array of sounds this tile makes when interacted with.
#The array above is used for randomly determined notes within a scale, to ensure audio stays in tune.

@export_category("Tile Tags") #These are tags don't do anything on their own, they're used for trigger checks by tiles
@export var tagsDatabase:Dictionary

@export_category("Interaction Extras") #These are the fields to input triggers, and which tiles or tags fit them.
#Unsure how to organize this yet, to make sure it calls the right functions if tiles or inputs are present
#This may also be where resources are instead extended into subresources
@export var trigFlowTile:Vector2i #The coords of the tile that affected this one. Used for Water and Magma.

func UpdateOnTile(map:WorldMap, coords:Vector2i):
	if map.hexDatabase[coords].entityOnTile != null:
		map.hexDatabase[coords].entityOnTile.UpdateEntity(map)

func UpdateHex(map:WorldMap, coords:Vector2i):
	#When in doubt, allow tile to be turned fertile by a worker
	#if map.hexDatabase[coords].entityOnTile != null:
		#map.hexDatabase[coords].entityOnTile.UpdateEntity(map)
	pass #For subresource, list all possible trigger/effect combos as ordered if statements
	#if triggerX(map, coords) == true:
	#	doEventY(tiletype)

func TendHex(map:WorldMap, coords:Vector2i):
	pass
	#if EntityTrig(map, coords, "Worker"):
		#map.AddRemoveTag(coords, "Fertile", true)
		#map.hexDatabase[coords].alreadyChanged = true

func CheckHoneyCost(map:WorldMap, coords:Vector2i, actionType:String, staying:bool) -> int:
	var tile:Hex = map.hexDatabase[coords]
	var sizeCost:int = tile.stackCount
	var distanceCost:int = 1 + tile.ring
	var typeCost:int = 0
	var totalCost:int = 0
	var globalMultiplier:int = 10
	
	prints(sizeCost, distanceCost, typeCost, globalMultiplier, staying)
	
	if tile.tileType.name == "Stone":
		typeCost = 1
	elif tile.tileType.name == "Ash":
		typeCost = 1
	elif tile.tileType.name == "Brush":
		typeCost = 1
	elif tile.tileType.name == "Forest":
		typeCost = 2
	elif tile.tileType.name == "Water":
		typeCost = 2
	elif tile.tileType.name == "Garden":
		typeCost = 0
	elif tile.tileType.name == "Wax":
		typeCost = 0
	elif tile.tileType.name == "Fire":
		typeCost = 3
	elif tile.tileType.name == "Magma":
		typeCost = 4
	print(totalCost)
	if actionType == "Worker":
		totalCost = (typeCost*sizeCost) + (float(distanceCost)/6)
		if tile.tileType.name == "Garden":
			totalCost = 0
			print("I'm tending a garden, no cost!")
	elif actionType == "Builder":
		totalCost = 6 + typeCost + (float(distanceCost)/6)
		if tile.tileType.name == "Wax":
			totalCost = 2
	elif actionType == "Gardener":
		totalCost = 1 + (float(distanceCost)/6)
	print(totalCost)
	totalCost *= globalMultiplier
	if staying:
		totalCost = float(totalCost) / 2
	return totalCost

#--Effect Functions Start Here--#
#
#func ChangeStack(map:WorldMap, coords:Vector2i, amount:int):
	#var targetTile:Hex = map.hexDatabase[coords]
	##play sound from targetTile.tileType.soundScale, scale position based on stack, octave based on +/-
	##As long as the amount change wouldn't take it below 0 or above max, change amount.
	#if targetTile.stackCount + amount > 0 and targetTile.stackCount + amount < targetTile.tileType.stackMax:
		#targetTile.stackCount += amount
	#elif targetTile.stackCount + amount <= 0:
		#pass
		##NoStackTrig(targetTile)
	#elif targetTile.stackCount + amount >= targetTile.tileType.stackMax:
		#pass
		##MaxStackTrig(targetTile)
#
#func ChangeTags(map:WorldMap, coords:Vector2i, tagsToAdd:Dictionary, soft:bool=false): 
	##Swap out tags on target tile. If "soft", adds tags instead of replacing.
	#var targetTile:Hex = map.hexDatabase[coords]
	#
	#if targetTile != null:
		#if soft == false:
			#targetTile.tags = tagsToAdd
		#else:
			#for tag in tagsToAdd:
				#if !targetTile.tags.has(tag):
					#targetTile.tags[tag] = tagsToAdd[tag]
				#elif targetTile.tags.has(tag) and targetTile.tags[tag] == false:
					#targetTile.tags[tag] = true
#
#func ChangeTile(map:WorldMap, coords:Vector2i, type:TileRuleset, stacks:int=1, soft:bool=false): 
	##Swap out target tile. If "soft", adds tags to resulting tile's tags. Optionally set stack count, default 1.
	#var targetTile:Hex = map.hexDatabase[coords]
	##play random sound from targetTile.tileType.soundScale
	#if targetTile != null and !targetTile.tags.has("Irreplacable"):
		#map.set_cell(0, coords, 2, type.tileIndex) #add stack count as alternate tile, needs RESEARCH
		#targetTile.tileType = type
		#targetTile.stackCount = stacks
		#ChangeTags(map, coords, type.tagsDatabase, soft)
		#if type.name == "Empty":
			#pass
			##RemovalTrig(targetTile)
#

#--Trigger Functions Start Here--#

func TileTrig(map:WorldMap, coords:Vector2i, targetType:TileRuleset) -> bool: 
	var targetTile:Hex = map.hexDatabase[coords]
	var trigger:bool
	if targetTile.tileType == targetType:
		trigger = true
	return trigger

func AdjacentTrig(map:WorldMap, coords:Vector2i, targetType:TileRuleset) -> Array: 
	var currentTile:Hex = map.hexDatabase[coords]
	var neighbors = map.GetAllAdjacent(coords)
	var trigTiles:Array
	for tile in neighbors:
		if currentTile.tileType == targetType:
			trigTiles.append(tile)
	return trigTiles

func CompareTrig(map:WorldMap, coords:Vector2i, targetCoords:Vector2i, lowHigh:bool) -> bool: 
	#for lowHigh, false if checking for target lower than current, true if checking for higher
	var currentTile:Hex = map.hexDatabase[coords]
	var targetTile:Hex = map.hexDatabase[targetCoords]
	var trigger:bool
	if lowHigh == false:
		if currentTile.stackCount > targetTile.stackCount: #True if current higher than target
			trigger = true
			#print("Target lower in stacks")
	else:
		if currentTile.stackCount < targetTile.stackCount: #True if target higher than current
			trigger = true
	return trigger

func TagTrig(map:WorldMap, coords:Vector2i, targetTag:String) -> bool:
	var targetTile:Hex = map.hexDatabase[coords]
	var trigger:bool = false
	if targetTile.tags.has(targetTag):
		trigger = targetTile.tags[targetTag]
	return trigger

func MinMaxTrig(map:WorldMap, coords:Vector2i, minMax:bool) -> bool: 
	#for minMax, false if checking for stacks = 1 or 0, true if checking for max
	var targetTile:Hex = map.hexDatabase[coords]
	var trigger:bool
	if minMax == false:
		if targetTile.stackCount <= 1:
			trigger = true
	else:
		if targetTile.stackCount >= targetTile.tileType.stackMax: 
			trigger = true
	return trigger

func TimeTrig(map:WorldMap, coords:Vector2i):
	var targetTile:Hex = map.hexDatabase[coords]
	var trigger:bool = false
	if targetTile.counter == 0:
		trigger = true
	return trigger

func EntityTrig(map:WorldMap, coords:Vector2i, targetEntity:String) -> bool:
	var targetTile:Hex = map.hexDatabase[coords]
	var trigger:bool = false
	if targetTile.entityOnTile == null:
		return trigger
	if targetTile.entityOnTile.name == targetEntity:
		trigger = true
	return trigger

#--adjacent trigger - Done! (Untested)
#--higher than trigger - Done! (Untested)
#--lower than trigger - Done! (Untested)
#--tag check trigger - Done! (Untested)
#--tile check trigger - Done! (Untested)
#--max stack trigger - Done! (Untested)
#--time trigger - Done! (Untested)
#--min stacks trigger - Done! (Untested)
#--worker trigger - Done! (Untested)
