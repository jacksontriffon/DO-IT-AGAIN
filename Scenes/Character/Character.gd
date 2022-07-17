extends KinematicBody2D


const ACCELERATION = 500
const MAX_SPEED = 128
var friction = 0.8
const AIR_RESISTANCE = 0.25
const GRAVITY = 600
var jump_force = 208

var motion := Vector2.ZERO
var in_air := false
var running := false
var respawning := true
var zapped := false
var anti_gravity := false


var gaining_new_ability := false
var current_ability : String
var abilities := [
	'Unlucky',
	'Feather Falling',
	'AntiGrav',
	'Double Jump',
	'Wall Jump',
]


var walking_sfx = preload('res://Scenes/Character/SFX/Walking.wav')
var zap_sfx = preload('res://Scenes/Character/SFX/Zap.wav')
var jump_sfx = preload('res://Scenes/Character/SFX/Jump.mp3')
var dice_sfx = preload('res://Scenes/Character/SFX/Dice.wav')
var death_sfx = preload('res://Scenes/Character/SFX/Death.wav')
var thud_sfx = preload('res://Scenes/Character/SFX/Thud.mp3')
var sfx := {
	'Walking': walking_sfx,
	'Zap': zap_sfx,
	'Jump': jump_sfx,
	'Dice': dice_sfx,
	'Death': death_sfx,
	'Thud': thud_sfx,
}

onready var sprite: Sprite = $Sprite
onready var animation: AnimationPlayer = $AnimationPlayer
onready var camera: Camera2D = $Camera2D
onready var audio: AudioStreamPlayer = $AudioStreamPlayer2D
onready var ability_icon: Sprite = $"%AbilityIcon"
onready var ability_label: Label = $"%AbilityText"

var cloudhead_spritesheet = preload('res://Scenes/Character/Sprites/Cloudhead/MC-cloud-Sheet.png')
var unlucky_spritesheet = preload('res://Scenes/Character/Sprites/Default/MC-Sheet.png')
var antigrav_spritesheet = preload('res://Scenes/Character/Sprites/AntiGrav/MC-Antigrav-Sheet.png')
var ninja_spritesheet = preload('res://Scenes/Character/Sprites/Ninja/MC-Ninja-Sheet.png')
var angel_spritesheet = preload('res://Scenes/Character/Sprites/Angel/MC-WingsSheet.png')


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_respawn()
	Player.connect("died", self, '_die')
	Player.connect("on_ice", self, '_apply_slipping')
	Player.connect("off_ice", self, '_stop_slipping')
	Player.connect("zap", self, '_zap')
	Player.connect("roll_the_dice", self, '_roll_the_dice')
	Player.connect('win', self, '_win')
	Player.connect("lifted", self, '_lifted')
	$Zap.visible = false
	$Beam.visible = false
	$Dice.visible = false
	$Diamond.visible = false
	$AbilityContainer.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _physics_process(delta: float) -> void:
	match current_ability:
		'Feather Falling':
			_apply_feather_falling(delta)
		'AntiGrav':
			_check_for_antigrav(delta)
		_:
			_apply_gravity(delta)
		
	# Get motion
	motion = move_and_slide(motion, Vector2.UP)
	_apply_falling_death(motion)
	
	# Prevent everything
	if Player.dead or respawning or zapped or gaining_new_ability:
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
	elif Input.is_action_just_released("ui_up") and motion.y < -jump_force / 2:
		motion.y = -jump_force / 2


func _check_for_movement(delta:float)->void:
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if x_input != 0:
		_apply_acceleration(x_input, delta)
	# Idle
	else:
		running = false

func _jump()->void:
	
	match current_ability:
#		'Unlucky':
#			pass
		'Feather Falling':
			animation.play("cloudhead_float")
			motion.y = -jump_force
			in_air = true
			# SFX
			audio.stream = sfx.Jump
			audio.play()
		'AntiGrav':
			# Upside down
			if anti_gravity:
				motion.y = -jump_force
				in_air = true
				anti_gravity = false
			# Normal + Inverse gravity
			else:
				anti_gravity = true
				motion.y = jump_force
				in_air = true
#		'Double Jump':
#			pass
#		'Wall Jump':
#			pass
		_:
			animation.play("default_jump")
			motion.y = -jump_force
			in_air = true
			# SFX
			audio.stream = sfx.Jump
			audio.play()

func _land()->void:
	animation.play("default_land")
	in_air = false

func _die()->void: # Connected to 'died' signal
	if not Player.dead:
		Player.dead = true
		animation.play("default_die")
		audio.stream = sfx.Death
		audio.play()
		yield(animation, "animation_finished")
		camera.current = true
		# Trigger scene transition
		Player.respawn()
		queue_free()

func _respawn() -> void:
	_unlucky()
	# Falling animation
	animation.play("default_die")
	animation.seek(0.3)
	
	# Thud sound ~ removed
	var time_until_getting_up = 1.3
	var time_until_hit_ground = 0.35
	yield(get_tree().create_timer(time_until_hit_ground),"timeout")
#	audio.stream = sfx.Thud
#	audio.volume_db = 0
##	audio.play()
	var time_left = time_until_getting_up - time_until_hit_ground
	yield(get_tree().create_timer(time_left),"timeout")
#	audio.volume_db = 0
	
	if not gaining_new_ability:
		# Getting up animation
		animation.play_backwards("default_die")
	else:
		pass
	yield(get_tree().create_timer(0.7), "timeout")
	# Finish respawning
	respawning = false
	

func _zap() -> void:
	if not zapped:
		_unlucky()
		zapped = true
		$Zap.visible = true
		animation.play("zap")
		audio.stream = sfx.Zap
		audio.play()
		yield(get_tree().create_timer(2), "timeout")
		$Zap.visible = false
		_die()

func _win()->void:
	if not Player.won_this_run:
		Player.wins.push_back(current_ability)
		Player.won_this_run = true

func _lifted()->void:
	var court_height = -980
	position.y = min(position.y, court_height)
	motion.y = -jump_force

# --- ABILITIES ---
func _roll_the_dice():
	# Prevent movement
	gaining_new_ability = true
	$Beam.visible = true
	$Dice.visible = true
	$Diamond.visible = true
	# Start animation
	animation.play("roll_the_dice")
	yield(get_tree().create_timer(2), "timeout")
	# Find Ability
	var random_number = get_random_number()
	_new_ability(random_number)
	$AbilityContainer.visible = true
	yield(get_tree().create_timer(1), "timeout")
	
	$Beam.visible = false
	$Dice.visible = false
	$Diamond.visible = false
	gaining_new_ability = false
	
	yield(get_tree().create_timer(2), "timeout")
	$AbilityContainer.visible = false

func get_random_number()-> int:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var random_number = rng.randf_range(0, 2.9) # Only first 3 values 
	random_number = int(random_number)
	return random_number

func _new_ability(number:int)->void:
	current_ability = abilities[number]
	ability_label.text = current_ability
	
	match current_ability:
		'Unlucky':
			ability_icon.frame = 4
			_unlucky()
		'Feather Falling':
			ability_icon.frame = 3
			_unlock_feather_falling()
		'AntiGrav':
			ability_icon.frame = 0
			_unlock_antigrav()
		'Double Jump':
			_unlock_double_jump()
			ability_icon.frame = 2
		'Wall Jump':
			_unlock_wall_jump()
			ability_icon.frame = 1
		_:
			current_ability = 'Unlucky'
			ability_icon.frame = 4
	
	print(current_ability)

func _unlock_feather_falling()->void:
	$Sprite.texture = cloudhead_spritesheet
	$Sprite.hframes = 13

func _unlock_antigrav()->void:
	$Sprite.texture = antigrav_spritesheet
	$Sprite.hframes = 12

func _unlock_double_jump()->void:
	$Sprite.texture = angel_spritesheet
	$Sprite.hframes = 15

func _unlock_wall_jump()->void:
	$Sprite.texture = ninja_spritesheet
	$Sprite.hframes = 15

func _unlucky()->void:
#	anti_gravity = false
	$Sprite.texture = unlucky_spritesheet
	$Sprite.hframes = 15

# --- FORCES ---
func _apply_gravity(delta:float)->void:
	motion.y += GRAVITY * delta

func _apply_friction()->void:
	motion.x = lerp(motion.x, 0, friction)

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
#	if offscreen:
#		print(distance_from_camera)
#		print(offscreen)
##	if distance_from_camera < 0: 
##		print(distance_from_camera, ' | motion: ' + str(motion) + ' | Viewport:' + str(get_viewport().get_position_in_parent()))
##
#
#	# Die when offscreen and moving too fast
#	if motion.y > 600 and offscreen and not respawning:
#		print(distance_from_camera, ' | ' + str(motion))
		

func _apply_slipping()->void:
	friction = 0.01

func _stop_slipping()->void:
	friction = 0.8

func _check_for_antigrav(delta)->void:
	if Player.won_this_run:
		motion.y += (GRAVITY * delta)
	elif anti_gravity:
		motion.y -= (GRAVITY * delta)
	else:
		motion.y += (GRAVITY * delta)

func _apply_feather_falling(delta:float)->void:
	jump_force = 90
	var percentage_of_gravity = 0.2
	motion.y += (GRAVITY * delta) * percentage_of_gravity
