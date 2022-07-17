extends StaticBody2D

var still_on_ice = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_class("KinematicBody2D") and not Player.slippery:
		Player.slip()
		still_on_ice = true
		yield(get_tree().create_timer(0.5),"timeout")
		still_on_ice = false
		Player.stop_slipping()


#func _on_Area2D_body_exited(body: Node) -> void:
#	if body.is_class("KinematicBody2D") and Player.slippery and not still_on_ice:
#		Player.stop_slipping()
#
