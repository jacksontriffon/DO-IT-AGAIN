extends Node

# --- DATA ---
# Here's a place to send signals but NOT set data.
# That's done from nodes outside the autoload.

var dead = false
var slippery = false

signal died
signal screen_hidden
signal respawn
signal on_ice
signal off_ice
signal zap
signal new_game
signal transition
signal roll_the_dice
signal new_ability_unlocked

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func death() -> void:
	emit_signal("died")

func respawn() -> void:
	if dead:
		emit_signal("respawn")

func slip() -> void:
	if not slippery:
		slippery = true
		emit_signal("on_ice")

func stop_slipping() -> void:
	if slippery:
		slippery = false
		emit_signal("off_ice")

func zap() -> void:
	emit_signal('zap')

func new_game() -> void:
	emit_signal("new_game")

func transition() -> void:
	emit_signal("transition")

func roll_the_dice() -> void:
	emit_signal("roll_the_dice")



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
