extends Node

# --- DATA ---
# Here's a place to send signals but NOT set data.
# That's done from nodes outside the autoload.

var wins := []
var camera: MainCamera = null

var dead = false
var slippery = false
export var just_launched := false
var won_this_run := false
var music_playing := false
var previous_ability: String
var abilities_to_choose_from := []
var first_run := true

signal died
signal respawn
signal on_ice
signal off_ice
signal zap
signal lifted
signal new_game
signal transition
signal roll_the_dice
signal win
signal gate_opened
signal beat_the_game
signal start_bg_music
signal end_bg_music
signal in_court
signal inverted_gravity(boolean)
signal screen_shake(intensity, time, limit)
signal follow(true_or_false)
signal tutorial(tut_name)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	just_launched = true

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

func shake(intensity: float, time: float = 0.4, limit: float = 100)->void:
	emit_signal('screen_shake', intensity, time, limit)

func follow(true_or_false := true)->void:
	emit_signal('follow', true_or_false)

func in_court()->void:
	emit_signal("in_court")

func invert_gravity(boolean: bool)->void:
	emit_signal("inverted_gravity", boolean)

func trigger_tutorial(tut_name:String)->void:
	emit_signal("tutorial", tut_name)




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
