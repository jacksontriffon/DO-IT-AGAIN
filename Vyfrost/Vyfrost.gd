extends CanvasLayer


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
onready var world = preload('res://World.tscn')


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("glitch-in-vyfrost")
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene_to(world)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
