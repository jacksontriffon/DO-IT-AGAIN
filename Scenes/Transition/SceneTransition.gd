extends CanvasLayer

onready var animation: AnimationPlayer = $AnimationPlayer

signal screen_hidden

func change_scene(target: String) -> void:
	animation.play("fadein")
	yield(animation, "animation_finished")
	get_tree().change_scene(target)
	animation.play_backwards("fadein")

func respawn() -> void:
#	animation.play("clouds")
#	animation.play("fadein")
	yield(animation,"animation_finished")
	animation.play_backwards("clouds")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Player.connect("respawn", self, 'respawn')


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
