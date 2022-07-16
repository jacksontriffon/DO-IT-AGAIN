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
var respawning = true

onready var sprite: Sprite = $Sprite
onready var animation: AnimationPlayer = $AnimationPlayer
onready var camera: Camera2D = $Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_respawn()
	Player.connect("died", self, '_die')


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	# Get motion
	motion = move_and_slide(motion, Vector2.UP)
	_apply_falling_death(motion)
	
	# Prevent everything
	if Player.dead or respawning:
		motion.x = 0
		return
	
	# Movement
	_check_for_movement(delta)
	
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
		if not running:
			_apply_friction()
		# Jump 
		if Input.is_action_pressed("ui_up"):
			_jump()
		elif in_air:
			_land()
		
	# Air friction
	elif not running:
		_apply_air_resistance()
	# Released jump early
	elif Input.is_action_just_released("ui_up") and motion.y < -JUMP_FORCE / 2:
		motion.y = -JUMP_FORCE / 2
	

func _check_for_movement(delta:float)->void:
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if x_input != 0:
		_apply_acceleration(x_input, delta)
	# Idle
	else:
		running = false

func _jump()->void:
	motion.y = -JUMP_FORCE
	in_air = true
	animation.play("default_jump")

func _land()->void:
	animation.play("default_land")
	in_air = false

func _die()->void: # Connected to 'died' signal
	if not Player.dead:
		Player.dead = true
		animation.play("default_die")
		yield(animation, "animation_finished")
		camera.current = true
		# Trigger scene transition
		Player.respawn()
		queue_free()

func _respawn() -> void:
	# Falling animation
	animation.play("default_die")
	animation.seek(0.3)
	yield(get_tree().create_timer(1.3),"timeout")
	# Getting up animation
	animation.play_backwards("default_die")
	yield(get_tree().create_timer(0.7), "timeout")
	# Finish respawning
	respawning = false

# --- FORCES ---
func _apply_gravity(delta:float)->void:
	motion.y += GRAVITY * delta

func _apply_friction()->void:
	motion.x = lerp(motion.x, 0, FRICTION)

func _apply_acceleration(x_input:float, delta:float)->void:
	motion.x += x_input * ACCELERATION * delta
	motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
	sprite.flip_h = x_input < 0
	running = true

func _apply_air_resistance()->void:
	motion.x = lerp(motion.x, 0, AIR_RESISTANCE)

func _apply_falling_death(motion: Vector2)->void:
	var normal_camera_height = -45
	var distance_from_camera = (camera.get_camera_position().y - position.y) - normal_camera_height
	var max_distance_from_camera = 0
	# Find when offscreen
	var offscreen = (max_distance_from_camera - distance_from_camera) < 0
	if offscreen:
		print(distance_from_camera)
		print(offscreen)
#	if distance_from_camera < 0: 
#		print(distance_from_camera, ' | motion: ' + str(motion) + ' | Viewport:' + str(get_viewport().get_position_in_parent()))
#
	
	# Die when offscreen and moving too fast
	if motion.y > 600 and offscreen and not respawning:
		print(distance_from_camera, ' | ' + str(motion))
		
