extends Node2D


onready var animation: AnimationPlayer = $AnimationPlayer
onready var camera: Camera2D = $Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_rile_up_court()


func _rile_up_court():
	animation.play("Crowd")
	
	# Get Jury moving
	$Jury/AntiGrav/AnimationPlayer.play("AntiGrav")
	$Jury/Ninja/AnimationPlayer.play("Ninja")
	$Jury/Angel/AnimationPlayer.play("Angel")
	$Jury/Warrior/AnimationPlayer.play("Warrior")
	$Jury/Cloudhead/AnimationPlayer.play("Cloudhead")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Area2D_body_entered(body: Node) -> void:
#	camera.current = true
	pass
