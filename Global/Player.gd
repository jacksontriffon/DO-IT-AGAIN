extends Node

# --- DATA ---
# Here's a place to send signals but NOT set data.
# That's done from nodes outside the autoload.

var wins := []

var dead = false
var slippery = false
export var just_launched := false
var won_this_run := false
var music_playing := false

signal died
signal screen_hidden
signal respawn
signal on_ice
signal off_ice
signal zap
signal lifted
signal new_game
signal transition
signal roll_the_dice
signal new_ability_unlocked
signal win
signal gate_opened
signal beat_the_game
signal start_bg_music
signal end_bg_music

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	just_launched = true
	yield(get_tree().create_timer(1), "timeout")
	just_launched = false
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

func lifted() -> void:
	emit_signal("lifted")

func new_game() -> void:
	emit_signal("new_game")

func transition() -> void:
	emit_signal("transition")

func roll_the_dice() -> void:
	emit_signal("roll_the_dice")

func win()->void:
	if not just_launched:
		emit_signal("win")

func open_gate()->void:
	emit_signal("gate_opened")

func beat_the_game()->void:
	emit_signal("beat_the_game")

func start_bg_music()->void:
	if not music_playing:
		emit_signal("start_bg_music")
		music_playing = true

func end_bg_music()->void:
	if music_playing:
		emit_signal("end_bg_music")
		music_playing = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
