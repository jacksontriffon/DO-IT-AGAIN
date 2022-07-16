extends Node

# --- DATA ---
# Here's a place to send signals but NOT set data.
# That's done from nodes outside the autoload.

var dead = false

signal died
signal respawn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func death() -> void:
	emit_signal("died")

func respawn() -> void:
	if dead:
		emit_signal("respawn")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
