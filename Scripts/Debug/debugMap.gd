extends WorldMap

var setTile:TileRuleset

func _ready():
	WorldSetup()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if Input.is_action_pressed("Menu1"):
		setTile = preload("res://Scripts/Resources/Tiles/Empty.tres")
	if Input.is_action_pressed("Menu2"):
		setTile = preload("res://Scripts/Resources/Tiles/Forest.tres")
	if Input.is_action_pressed("Menu3"):
		setTile = preload("res://Scripts/Resources/Tiles/Water.tres")
	if Input.is_action_pressed("Menu4"):
		setTile = preload("res://Scripts/Resources/Tiles/Garden.tres")
	if Input.is_action_pressed("LeftClick"):
		var selected = local_to_map(get_global_mouse_position() / self.scale)
		#prints(selected, setTile.name)
		ChangeTile(selected, setTile)
		for tile in GetAllAdjacent(selected):
			if get_cell_tile_data(0, tile) == null:
				await get_tree().create_timer(0.1).timeout
				set_cell(0, tile, 2, Vector2(0,0), 0)
				var newHex:Hex = Hex.new()
				var hexData:TileData = get_cell_tile_data(0, tile)
				newHex.gridCoords = tile
				newHex.tileType = hexData.get_custom_data("Tile Ruleset")
				newHex.stackCount = hexData.get_custom_data("Stack Count")
				newHex.tags = newHex.tileType.tagsDatabase
				hexDatabase[tile] = newHex
				#prints(tile, hexDatabase[tile].tileType.name)
	
	if Input.is_action_just_pressed("ProgressTurn"):
		WorldTurn()
