extends Sprite
class_name JudgeGod


onready var animation:AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()
	Player.connect("new_game", self, 'new_game')

func new_game() -> void:
	animation.play("Talk")
	var dialogue = Dialogic.start('NewGame')
	add_child(dialogue)
	dialogue.connect('dialogic_signal', self, 'zap')

func zap(dialogic_argument) -> void:
	if dialogic_argument == 'new_game_dialogue_finished':
		animation.play("Gavel")
		yield(animation, "animation_finished")
		Player.zap()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
