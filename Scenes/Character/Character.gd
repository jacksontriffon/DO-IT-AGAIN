extends KinematicBody2D


const ACCELERATION = 500
const MAX_SPEED = 128
const FRICTION = 0.8
const AIR_RESISTANCE = 0.25
const GRAVITY = 600
const JUMP_FORCE = 208

var motion = Vector2.ZERO
var in_air = false
var running = false

onready var sprite: Sprite = $Sprite
onready var animation: AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	
	# Movement
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if x_input != 0:
		_apply_acceleration(x_input, delta)
	# Idle
	else:
		running = false
	
	# Animation
	if in_air:
		# Maintain jump animation
		pass
	elif running:
		animation.play("default_walk")
	else:
		animation.play("default_idle")
	
	
	
	if is_on_floor():
		# Slowed by friction
		if x_input == 0:
			_apply_friction()
		
		# Jump 
		if Input.is_action_pressed("ui_up"):
			_jump()
		elif in_air:
			animation.play("default_land")
			in_air = false
		
		
		# Land
#		if in_air:
#			animation.play("default_land")
#			in_air = false
		
		# Crouch
#		if Input.is_action_pressed("ui_down"):
#			animation.play("default_crouch")
		
	# Air friction
	elif x_input == 0:
		motion.x = lerp(motion.x, 0, AIR_RESISTANCE)
	# Released jump early
	elif Input.is_action_just_released("ui_up") and motion.y < -JUMP_FORCE / 2:
		motion.y = -JUMP_FORCE / 2
	
	motion = move_and_slide(motion, Vector2.UP)


func _jump()->void:
	motion.y = -JUMP_FORCE
	in_air = true
	animation.play("default_jump")

func _crouch()->void:
	pass


func _apply_gravity(delta:float)->void:
	motion.y += GRAVITY * delta

func _apply_friction()->void:
	motion.x = lerp(motion.x, 0, FRICTION)

func _apply_acceleration(x_input:float, delta:float)->void:
	motion.x += x_input * ACCELERATION * delta
	motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
	sprite.flip_h = x_input < 0
	running = true
