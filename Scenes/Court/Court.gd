extends Node2D


onready var animation: AnimationPlayer = $AnimationPlayer
onready var camera: Camera2D = $Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_rile_up_court()
	Player.connect("gate_opened", self, '_open_gate')


func _rile_up_court():
	animation.play("Crowd")
	
	# Get Jury moving
	$Jury/AntiGrav/AnimationPlayer.play("AntiGrav")
	$Jury/Ninja/AnimationPlayer.play("Ninja")
	$Jury/Angel/AnimationPlayer.play("Angel")
	$Jury/Warrior/AnimationPlayer.play("Warrior")
	$Jury/Cloudhead/AnimationPlayer.play("Cloudhead")

func _open_gate()->void:
	animation.play("Open_gate")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Area2D_body_entered(body: Node) -> void:
	Player.lifted()
	_rile_up_court()
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


