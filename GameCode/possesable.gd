extends RigidBody2D

var is_possesed = false
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

func invoke_possession():
	if is_possesed:
		return false
	is_possesed = true
	return true
