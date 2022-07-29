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
	dialogue.connect('dialogic_signal', self, 'respond_to_dialogic')

func do_it_again()-> void:
	if not Player.just_launched:
		animation.play("Talk")
		var dialogue = Dialogic.start('DOITAGAIN')
		add_child(dialogue)
		dialogue.connect('dialogic_signal', self, 'respond_to_dialogic')

func do_it_again_again()->void:
	animation.play("Talk")
	var dialogue = Dialogic.start('DOITAGAINAGAIN')
	add_child(dialogue)
	dialogue.connect('dialogic_signal', self, 'respond_to_dialogic')

func approves()->void:
	animation.play("Talk")
	var dialogue = Dialogic.start('Approved')
	add_child(dialogue)
	dialogue.connect('dialogic_signal', self, 'respond_to_dialogic')


func respond_to_dialogic(argument) -> void:
	if argument == 'new_game_dialogue_finished':
		animation.play("Gavel")
		yield(animation, "animation_finished")
		Player.zap()
		Player.won_this_run = false
	elif argument == 'do_it_again':
		animation.play("Gavel")
		yield(animation, "animation_finished")
		Player.zap()
		Player.won_this_run = false
	elif argument == 'do_it_again_again':
		animation.play("Gavel")
		yield(animation, "animation_finished")
		Player.zap()
		Player.won_this_run = false
	elif argument == 'gate_open':
		Player.open_gate()
	elif argument == 'beat_the_game':
		Player.beat_the_game()
		Player.won_this_run = false
		animation.stop()
		animation.seek(0)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
