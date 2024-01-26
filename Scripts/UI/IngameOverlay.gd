extends Node

@export var PauseOverlay:Node
var PauseShown:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	PauseOverlay.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pause_button_pressed():
	if PauseShown == false:
		PauseOverlay.show()
		PauseShown = true
	else:
		PauseOverlay.hide()
		PauseShown = false


func _on_quit_pressed():
	get_tree().quit()


func _on_end_turn_button_pressed():
	pass # Replace with function body.


func _on_worker_button_pressed(WorkerIndex:int):
	pass # Replace with function body.


func _on_auto_toggle_pressed():
	pass # Replace with function body.


func _on_options_pressed():
	pass # Replace with function body.


func _on_show_tutorial_pressed():
	pass # Replace with function body.


func _on_return_to_title_pressed():
	pass # Replace with function body.
