extends AudioStreamPlayer

var orderedSFX:Array

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func UpdateBacklog(map:WorldMap, updateOrder:Array):
	for tile in updateOrder:
		var sfxArray = map.hexDatabase[tile].tileType.soundScale
		var sfx = sfxArray[RandomNumberGenerator.new().randi_range(0,5)]
		orderedSFX.append(sfx)
		print(orderedSFX)

func PlayBacklog():
	for sfx in orderedSFX:
		var delay = RandomNumberGenerator.new().randf_range(0.4,2.0)
		self.stream = sfx
		play()
		await get_tree().create_timer(delay).timeout
