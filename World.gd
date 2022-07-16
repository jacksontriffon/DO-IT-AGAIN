extends Node2D


onready var starting_camera : Camera2D = $StartingCamera
onready var character_scene = preload('res://Scenes/Character/Character.tscn')

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	respawn()
	Player.connect("respawn", self, 'respawn')

func respawn()->void:
	Player.dead = false
	# Spawn new player
	var character = character_scene.instance()
	$YSort.add_child(character)
	$YSort.move_child(character, 0)
	character.position = Vector2(32, -170)
	# Set camera position
	var starting_camera := Camera2D.new()
	add_child(starting_camera)
	starting_camera.position = Vector2(160,90)
	starting_camera.current = true
	yield(get_tree().create_timer(1),"timeout")
	starting_camera.queue_free()
	# View player
	var player_camera: Camera2D = character.get_node("Camera2D")
	player_camera.position = Vector2(130,-45) # Prevent camera shake when switching camera
	player_camera.current = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
