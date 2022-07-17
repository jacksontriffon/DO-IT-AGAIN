extends CanvasLayer
class_name SceneTransition

onready var animation: AnimationPlayer = $AnimationPlayer

signal screen_hidden

#func change_scene(target: String) -> void:
#	animation.play("fadein")
#	yield(animation, "animation_finished")
#	get_tree().change_scene(target)
#	animation.play_backwards("fadein")

func clouds() -> void:
	animation.play("clouds")
	yield(get_tree().create_timer(0.5),"timeout")
	emit_signal("screen_hidden")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Player.connect("transition", self, 'clouds')


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
