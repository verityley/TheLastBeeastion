extends WorldMap

var beeType:String = "Worker"
var auto:bool = false
#var setTile:TileRuleset = preload("res://Scripts/Resources/Tiles/Empty.tres")

func _ready():
	WorldSetup()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if Input.is_action_pressed("Menu1"):
		beeType = "Worker"
	if Input.is_action_pressed("Menu2"):
		beeType = "Gardener"
	if Input.is_action_pressed("Menu3"):
		beeType = "Builder"
		#setTile = preload("res://Scripts/Resources/Tiles/Water.tres")
	#if Input.is_action_pressed("Menu4"):
		#setTile = preload("res://Scripts/Resources/Tiles/Garden.tres")
	if Input.is_action_just_pressed("LeftClick"):
		var selected = local_to_map(get_global_mouse_position() / self.scale)
		#prints(selected, setTile.name)
		if get_cell_tile_data(0, selected) != null:
			if hexDatabase[selected].entityOnTile != null and (
				hexDatabase[selected].entityOnTile.name == "Worker" or 
				hexDatabase[selected].entityOnTile.name == "Gardener" or 
				hexDatabase[selected].entityOnTile.name == "Builder"
			):
				ChangeEntity(selected, null, true)
				#availableWorkers + 1
			elif hexDatabase[selected].inWorkerRange == true and (
				availableWorkers > 0 and hexDatabase[selected].entityOnTile == null):
				ChangeEntity(selected, HexTypes.entity[beeType].duplicate())
				availableWorkers -= 1
				
		print("Workers: ", availableWorkers, " Max: ", workerMax)
	#
	#if Input.is_action_pressed("RightClick"):
		#var selected = local_to_map(get_global_mouse_position() / self.scale)
		##prints(selected, setTile.name)
		#if get_cell_tile_data(0, selected) != null: 
			#ChangeTile(selected, HexTypes.type["Fire"], 1)
		#for tile in GetAllAdjacent(selected):
			#if get_cell_tile_data(0, tile) == null:
				#await get_tree().create_timer(0.1).timeout
				#set_cell(0, tile, 2, Vector2(0,0), 0)
				#var newHex:Hex = Hex.new()
				#var hexData:TileData = get_cell_tile_data(0, tile)
				#newHex.gridCoords = tile
				#newHex.tileType = hexData.get_custom_data("Tile Ruleset")
				#newHex.stackCount = hexData.get_custom_data("Stack Count")
				#newHex.tags = newHex.tileType.tagsDatabase
				#hexDatabase[tile] = newHex
				##prints(tile, hexDatabase[tile].tileType.name)
	
	if Input.is_action_just_pressed("ProgressTurn"):
		if auto == true:
			if $Timer.is_stopped():
				$Timer.start()
				print("Timer Started")
			else:
				$Timer.stop()
		else:
			WorldTurn()

#
func _on_timer_timeout():
	WorldTurn()
