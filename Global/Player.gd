extends Node

var dead = false

signal died
signal respawn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func death() -> void:
	emit_signal("died")
	dead = true
	print('death')

func respawn() -> void:
	emit_signal("respawn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
