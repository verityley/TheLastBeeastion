extends Camera2D

@export var dragSpeed:float = 1.0
@export var zoomSpeed:float = 0.02
@export var zoomMin:float = 0.1
@export var zoomMax:float = 0.6

var dragging:bool = false
var dragStart:Vector2
var camStart:Vector2
var zoomAmount:float = 0.3

func _process(delta):
	if dragging:
		var dragDelta = dragStart - get_global_mouse_position()
		dragDelta *= dragSpeed * zoom
		position += dragDelta

func _input(event):
	if Input.is_action_just_pressed("RightClick"):
		dragging = true
		dragStart = get_global_mouse_position()
		camStart = position
	if Input.is_action_just_released("RightClick"):
		dragging = false
	
	if Input.is_action_pressed("ZoomIn"):
		zoomAmount = clampf(zoomAmount + zoomSpeed, zoomMin, zoomMax)
		zoom = Vector2(zoomAmount, zoomAmount)
	if Input.is_action_pressed("ZoomOut"):
		zoomAmount = clampf(zoomAmount - zoomSpeed, zoomMin, zoomMax)
		zoom = Vector2(zoomAmount, zoomAmount)
