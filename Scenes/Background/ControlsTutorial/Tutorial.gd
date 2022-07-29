extends CanvasLayer



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Player.connect("tutorial", self, 'trigger_tutorial')


func trigger_tutorial(tut_name:String)->void:
	print('triggereed')
	match tut_name:
		'respawn':
			$AnimationPlayer.play("using_respawn")
		'ability':
			$AnimationPlayer.play("using_ability")
		'first':
			$AnimationPlayer.play("using_ability")
			yield($AnimationPlayer, "animation_finished")
			$AnimationPlayer.play("using_respawn")
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
