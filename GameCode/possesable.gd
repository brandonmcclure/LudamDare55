extends RigidBody2D

var is_possesed = false
var timer
# Called when the node enters the scene tree for the first time.
func _ready():
	contact_monitor = true
	max_contacts_reported = 10;
	
func _process(delta):
	if is_possesed:
		$AnimatedSprite2D.animation = "possesed"
	else:
		$AnimatedSprite2D.animation = "default"
func _on_body_entered(body):	
	print(get_contact_count())
	print('hit')
	if not body.is_in_group("player"):
		return
	print('player has possesed it')
func _on_timer_timeout() -> void:
	is_possesed = false
func invoke_possession():
	if is_possesed:
		return false
	is_possesed = true
	#timer = get_tree().create_timer(3)
	var timer := Timer.new()
	timer.wait_time = 3.0
	timer.one_shot = true
	timer.autostart = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	return true


