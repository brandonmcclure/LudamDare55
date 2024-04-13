extends CanvasLayer

@export var max_score: int

# Notifies `Main` node that the button has been pressed
signal start_game

var intro_text = "You have been wandering for as long as you can remember. You are what they call a ghost. Your goal is to gather a following of the living who will summon you back into your physical form. Watch out for the inquisitors dressed in white. It will be difficult, because in your current state you cannot interact very well with their world. Try to survive as long as you can, Good luck"

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	$Message.text = intro_text
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(5.0).timeout
	$StartButton.show()
func show_game_win():
	show_message("You were able to get enough followers to be summoned! Enjoy your new life!")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	$Message.text = intro_text
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(5.0).timeout
	$StartButton.show()
func update_time(timer):
	$TimerLabel.text = str(timer)
func update_score(score):
	$ScoreLabel.text = str(score)
	$summon_progress/TextureProgressBar.value = score  * 100 / max_score
func _on_start_button_pressed():
	$StartButton.hide()
	$Message.hide()
	start_game.emit()

func _on_message_timer_timeout():
	$Message.hide()
# Called when the node enters the scene tree for the first time.
func _ready():
	$Message.text = intro_text
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
