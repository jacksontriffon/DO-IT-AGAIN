extends StaticBody2D


var broken = true
onready var animation: AnimationPlayer = $"%AnimationPlayer"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_respawn()

func _respawn() -> void:
	visible = true
	$CollisionPolygon2D.disabled = false
	animation.play_backwards("Break")
	yield(animation,"animation_finished")
	broken = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_class("KinematicBody2D") and not broken:
		animation.play("Break")
		yield(animation,"animation_finished")
		$CollisionPolygon2D.disabled = true
		visible = false
		broken = true
		yield(get_tree().create_timer(5),"timeout")
		_respawn()
