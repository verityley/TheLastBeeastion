extends Node

@export var worldMap:WorldMap
@export var PauseOverlay:Node
@export var mainCam:Node
@export var honeyLabel:Node
@export var workerLabel:Node
@export var maxLabel:Node
@export var GardenPrice:Node
@export var WorkerPrice:Node
@export var BuilderPrice:Node
var tutorialScene = preload("res://Tutorial.tscn")
var paused:bool = false
var PauseShown:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	PauseOverlay.hide()
	GardenPrice.show()
	WorkerPrice.hide()
	BuilderPrice.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if paused == true:
		return
	
	var selected = worldMap.local_to_map(worldMap.get_global_mouse_position() / worldMap.scale)
	honeyLabel.text = str(worldMap.honey)
	workerLabel.text = str(worldMap.availableWorkers)
	maxLabel.text = str(worldMap.workerMax)
	if worldMap.hexDatabase.has(selected):
		if worldMap.hexDatabase[selected].inWorkerRange == false:
			GardenPrice.text = "X"
			WorkerPrice.text = "X"
			BuilderPrice.text = "X"
		else:
			GardenPrice.text = str(worldMap.hexDatabase[selected].tileType.CheckHoneyCost(worldMap, selected, "Gardener", false))
			WorkerPrice.text = str(worldMap.hexDatabase[selected].tileType.CheckHoneyCost(worldMap, selected, "Worker", false))
			BuilderPrice.text = str(worldMap.hexDatabase[selected].tileType.CheckHoneyCost(worldMap, selected, "Builder", false))


func _on_pause_button_pressed():
	if PauseShown == false:
		PauseOverlay.show()
		PauseShown = true
		worldMap.auto = false
	else:
		PauseOverlay.hide()
		PauseShown = false


func _on_quit_pressed():
	get_tree().quit()


func _on_end_turn_button_pressed():
	if paused == true:
		return
	$Timer.stop()
	worldMap.WorldTurn()
	


func _on_worker_button_pressed(WorkerIndex:int):
	if paused == true:
		return
	
	if WorkerIndex == 1:
		worldMap.beeType = "Gardener"
		GardenPrice.show()
		WorkerPrice.hide()
		BuilderPrice.hide()
	elif WorkerIndex == 2:
		worldMap.beeType = "Worker"
		GardenPrice.hide()
		WorkerPrice.show()
		BuilderPrice.hide()
	elif WorkerIndex == 3:
		worldMap.beeType = "Builder"
		GardenPrice.hide()
		WorkerPrice.hide()
		BuilderPrice.show()


func _on_auto_toggle_pressed():
	if paused == true:
		return
	
	if $Timer.is_stopped():
		$Timer.start()
		print("Timer Started")
	else:
		$Timer.stop()


func _on_options_pressed():
	pass # Replace with function body.


func _on_show_tutorial_pressed():
	get_tree().root.add_child(tutorialScene)


func _on_return_to_title_pressed():
	get_tree().change_scene_to_file("res://Intro.tscn")


func _on_timer_timeout():
	if paused == true:
		return
	
	worldMap.WorldTurn()


func _on_bee_tracker_pressed():
	if paused == true:
		return
	
	var tiles = worldMap.GetAllHexes(20)
	for tile in tiles:
		var entity = worldMap.hexDatabase[tile].entityOnTile
		if entity != null:
			if (entity.name == "Worker" or 
			entity.name == "Builder" or
			entity.name == "Gardener"):
				worldMap.ChangeEntity(tile, null, true)
