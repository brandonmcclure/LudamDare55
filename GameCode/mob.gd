extends RigidBody2D

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	screen_size = get_viewport_rect().size
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# screen_size.x
	if position.x < -(screen_size.x) or position.y < -(screen_size.y): 
		queue_free()
	var velocity = Vector2.ZERO # The player's movement vector.
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = velocity.y > 0
	
	position += velocity * delta
	#position = position.clamp(Vector2.ZERO, screen_size)
	pass
func _on_visible_on_screen_notifier_2d_screen_exited():
	print('mob is off the screen')
	queue_free()
