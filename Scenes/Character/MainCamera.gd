extends Camera2D
class_name MainCamera


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var shake_amount = 0
var default_offset: Vector2 = offset
onready var timer: Timer = $Timer
onready var tween: Tween = $Tween


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Player.camera = self
	set_process(false)
	Player.connect("screen_shake", self, 'shake')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	offset = Vector2(rand_range(-shake_amount, shake_amount), rand_range(-shake_amount, shake_amount)) * delta + default_offset


func shake(intensity: float, time: float = 0.4, limit: float = 100)->void:
#	current = true
	# Increase intensity
	shake_amount += intensity
	# Set limit
	shake_amount = clamp(shake_amount, 0, limit)
	# Only start game_loop when shaking
	tween.stop_all()
	set_process(true)
	# Set timer
	timer.wait_time = time
	timer.start()

func _on_Timer_timeout() -> void:
	# Reset shake
	shake_amount = 0
	set_process(false)
	# Tween
	tween.interpolate_property(self, 'offset', offset, default_offset, 
	0.1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()
