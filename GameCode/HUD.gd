extends CanvasLayer

@export var max_score: int
enum States {main_menu, pause_menu, play, game_over, game_win}
var _state : int = States.main_menu
# Notifies `Main` node that the button has been pressed
signal state_start_play
signal state_start_main_menu
signal state_start_pause_menu
signal state_start_game_over
signal state_start_game_win

var intro_text = "You have been wandering for as long as you can remember, you remember long ago being called a ghost. Your goal is to gather a following of the blue peasants who will summon you back into your physical form. Watch out for the inquisitors dressed in white. It will be difficult, because in your current state you cannot interact very well with their world, and you will need to stay near the blue peasants to keep influence with them. Try to survive as long as you can, Good luck."

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
func set_state(state):
	
	print('setting state to: ', States.find_key(state))
	if state == null:
		return
	_state = state
	if _state == States.play:
		$StartButton.hide()
		$Message.hide()
		
		$ScoreLabel.show()
		$TimerLabel.show()
		$TimerLabel/Label.show()
		$summon_progress/TextureProgressBar.show()
		$summon_progress/TextureRect.show()
		state_start_play.emit()
	if _state == States.main_menu:
		$ScoreLabel.hide()
		$TimerLabel.hide()
		$TimerLabel/Label.hide()
		$summon_progress/TextureProgressBar.hide()
		$summon_progress/TextureRect.hide()
		$Message.text = intro_text
		$StartButton.show()
	if _state == States.game_win:
		show_message("You were able to get enough followers to be summoned! Enjoy your new life! You only have 10 more seconds before it starts over again")
		await get_tree().create_timer(10.0).timeout
		set_state(States.main_menu)
	if _state == States.game_over:
		show_message("You are dead forever now... or if you wait 10 seconds it will all restart ")
		await get_tree().create_timer(10.0).timeout
		set_state(States.main_menu)
func show_game_over():
	set_state(States.game_over)
func update_time(timer):
	$TimerLabel.text = str(timer)
func update_score(score):
	$ScoreLabel.text = str(score)
	$summon_progress/TextureProgressBar.value = score  * 100 / max_score
func _on_start_button_pressed():
	set_state(States.play)
	
func _on_message_timer_timeout():
	$Message.hide()
# Called when the node enters the scene tree for the first time.
func _ready():
	set_state(States.main_menu)	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _state == States.main_menu:
		$Message.text = intro_text
	elif _state == States.play:
		$Message.text = ''
	pass
