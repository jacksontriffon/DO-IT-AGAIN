extends Node2D
var crowd_murmur = preload('res://Scenes/Court/Room/SFX/crowdtalk.wav')
var crowd_decibels = -20

onready var animation: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_rile_up_court()
	Player.connect("gate_opened", self, '_open_gate')
	Player.connect("beat_the_game", self, 'play_win_sound')


func _rile_up_court():
	animation.play("Crowd")
	$AudioStreamPlayer2.stream = crowd_murmur
	$AudioStreamPlayer2.volume_db = crowd_decibels
	$AudioStreamPlayer2.play()
	$Tween.stop_all()
	$Tween.interpolate_property($AudioStreamPlayer2, 'volume_db', -80,  crowd_decibels, 1)
	$Tween.start()
	Player.connect("zap", self, 'hush_crowd')
	Player.connect('gate_opened', self, 'hush_crowd')
	# Get Jury moving
	$Jury/AntiGrav/AnimationPlayer.play("AntiGrav")
	$Jury/Ninja/AnimationPlayer.play("Ninja")
	$Jury/Angel/AnimationPlayer.play("Angel")
	$Jury/Warrior/AnimationPlayer.play("Warrior")
	$Jury/Cloudhead/AnimationPlayer.play("Cloudhead")

func hush_crowd()->void:
	$Tween.stop_all()
	$Tween.interpolate_property($AudioStreamPlayer2, 'volume_db', crowd_decibels, -80, 1)
	$Tween.start()
	animation.stop()
	Player.disconnect("zap", self, 'hush_crowd')
	Player.disconnect("gate_opened", self, 'hush_crowd')

func _open_gate()->void:
	animation.play("Open_gate")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Area2D_body_entered(_body: Node) -> void:
	Player.lifted()
	Player.follow(false)
	_rile_up_court()
	Player.end_bg_music()
	if Player.won_this_run:
		return
	if Player.wins.empty():
		Player.win()
		$JudgeGod.do_it_again()
	elif Player.wins.size() == 1:
		Player.win()
		$JudgeGod.do_it_again_again()
	elif Player.wins.size() > 1:
		Player.win()
		$JudgeGod.approves()

func play_win_sound()->void:
	$AnimationPlayer.play("Win")
