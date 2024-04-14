extends Node

signal timer

@export var mob_scene: PackedScene
@export var num_of_concurrent_enemies = 10
@export var max_score = 100
var score
var play_time = 0
var ff_disable_mobs = false
var ff_disable_music = false


var _num_of_current_enemies = 0
var bg_music := AudioStreamPlayer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	bg_music.stream = load("res://art/background2.ogg")
	bg_music.stream_paused = true
	bg_music.autoplay = false
	
	add_child(bg_music)
	if not ff_disable_music:
		bg_music.play()
	
	$HUD.max_score = max_score
	#	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_num_of_current_enemies = get_tree().get_nodes_in_group("mobs")
	pass

func game_win():
	bg_music.stop()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.set_state(4)
func _on_score_timer_timeout():
	timer.emit()
	play_time += 1
	$HUD.update_time(play_time)
	if $player.number_currently_possesed == 0:
		return
	score += 1
	if score >= max_score:
		game_win()
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
func _on_mob_timer_timeout():
	if ff_disable_mobs:
		return
	if num_of_concurrent_enemies <= _num_of_current_enemies.size():
		return
	#print('spawning a mob')		
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	#print(mob_spawn_location)
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)


func _on_player_hit():
	bg_music.stop()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.set_state(3)


func _on_hud_state_start_play():
	
	if not bg_music.playing and not ff_disable_music:
		bg_music.play()
	get_tree().call_group("mobs", "queue_free")
	score = 0
	$player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
