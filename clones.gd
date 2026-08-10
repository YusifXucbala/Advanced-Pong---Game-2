extends Area2D

@export var lifetime: float = 7.0
@export var spacing: float = 90.0
@onready var clones_sound: AudioStreamPlayer2D = $Clones_Sound

var clone_ball_scene: PackedScene = preload("res://clone_ball.tscn")
var clone_football_ball_scene: PackedScene = preload("res://clone_football_ball.tscn")
var clone_basketball_ball_scene: PackedScene = preload("res://basketball_clone_ball.tscn")
var clone_voleyball_ball_scene: PackedScene = preload("res://clone_voleyball_ball.tscn")
var is_collected: bool = false
var number_ball : int = 1

func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
		
	await get_tree().create_timer(max(0.0, lifetime - 0.5)).timeout
	if not is_collected and is_instance_valid(self):
		var tween = create_tween()
		tween.tween_property(self, "modulate:a", 0.0, 0.5)
		await tween.finished
		if not is_collected and is_instance_valid(self):
			queue_free()

func _on_body_entered(body: Node2D) -> void:
	if is_collected:
		return
	
	if body.name == "Football_Ball":
		number_ball = 2
	elif body.name == "Basketball_Ball":
		number_ball = 3
	elif body.name == "Voleyball_Ball":
		number_ball = 4
		
	if body.name == "Ball" or body.name == "Football_Ball" or body.name == "Basketball_Ball" or body.name == "Voleyball_Ball":
		is_collected = true
		
		set_deferred("monitoring", false)
		hide()
		
		spawn_clones(body)
		
		clones_sound.play()
		await clones_sound.finished
		queue_free()

func spawn_clones(real_ball: Node2D) -> void:
	var parent_scene = get_parent()
	
	var current_dir: Vector2 = Vector2.RIGHT
	if "dir" in real_ball and real_ball.dir != Vector2.ZERO:
		current_dir = real_ball.dir.normalized()
	elif "velocity" in real_ball and real_ball.velocity != Vector2.ZERO:
		current_dir = real_ball.velocity.normalized()

	var ball_speed: float = 400.0
	if "speed" in real_ball and real_ball.speed > 0:
		ball_speed = real_ball.speed

	var perp_dir: Vector2 = Vector2(-current_dir.y, current_dir.x)
	var offsets = [-spacing, spacing] 

	# Store spawned clones to pick one for position exchange
	var spawned_clones: Array[Node2D] = []

	for offset in offsets:
		var clone: Node2D = null
	
		if number_ball == 1:
			clone = clone_ball_scene.instantiate()
		elif number_ball == 2:
			clone = clone_football_ball_scene.instantiate()
		elif number_ball == 3:
			clone = clone_basketball_ball_scene.instantiate()
		elif number_ball == 4:
			clone = clone_voleyball_ball_scene.instantiate()
		
		if clone != null:
			clone.global_position = real_ball.global_position + (perp_dir * offset)
			clone.speed = ball_speed
			clone.dir = current_dir
			
			parent_scene.call_deferred("add_child", clone)
			spawned_clones.append(clone)

	# Pick one clone at random and exchange position with real_ball
	if spawned_clones.size() > 0:
		var chosen_clone = spawned_clones.pick_random()
		var original_ball_pos = real_ball.global_position
		
		real_ball.global_position = chosen_clone.global_position
		chosen_clone.global_position = original_ball_pos
