extends Area2D

signal hit
var _debug = false
@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var velocity
var target_destination = null
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	velocity = Vector2.ZERO
	if _debug:
		var debug_message = get_node("debug_message")
		debug_message.text = 'test'
	hide()

func _input(event):
# Mouse in viewport coordinates.
	if _debug:
		var debug_message = get_node("debug_message")
		#debug_message.text = typeof(event)
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		#print("Mouse Click/Unclick at: ", event.position)
		target_destination = event.position
		print('set the dest: ', event.position)
		#elif event is InputEventMouseMotion:
			#print("Mouse Motion at: ", event.position)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target_destination != null:
		position = position.move_toward(target_destination,delta*speed)
		
	velocity = Vector2.ZERO
	 # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		target_destination = null
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		target_destination = null
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		target_destination = null
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		target_destination = null

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
	position = position.clamp(Vector2.ZERO, screen_size)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
func invoke_death():
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
	
func _on_body_entered(body):	
	if body.is_in_group("Enemy"):
		invoke_death()
	if body.is_in_group("possesable"):
		print('posses')

