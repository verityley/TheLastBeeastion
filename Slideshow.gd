extends Control

@export var slides:Array[Texture2D]
@export var slidePanel:Node
@export var toStartMenu:bool = false
@export var toFinale:bool = false
var currentSlide:int = 0

func _ready():
	$SlideshowPanel.texture = slides[0]

func _input(event):
	if Input.is_action_just_pressed("LeftClick"):
		currentSlide += 1
		if currentSlide >= slides.size():
			if toStartMenu == true:
				$StartButton.show()
			elif toFinale == true:
				get_tree().quit()
			else:
				get_tree().get_root().queue_free()
		else:
			$SlideshowPanel.texture = slides[currentSlide]


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Stages/GameWorldBase.tscn")
