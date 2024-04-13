extends RigidBody2D


# Called when the node enters the scene tree for the first time.
#func _ready():
	
func _on_body_entered(body):	
	print('hit')
	if not body.is_in_group("player"):
		return
	print('player has possesed it')
