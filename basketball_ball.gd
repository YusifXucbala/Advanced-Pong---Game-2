extends CharacterBody2D

@onready var panel: Panel = $"../Background/Panel"
@onready var basketball_ball_sound: AudioStreamPlayer2D = $Basketball_Ball_Sound
@onready var basketball_main_game: Node2D = $".."



var win_size : Vector2
const start_speed : int = 500
const accel : int  = 30
var speed : int
var dir : Vector2
const max_y_vector : float = 0.6
const max_speed : int = 1200
var is_speed_boosted : bool = false
var made_invisible : bool = false

func _ready():
	win_size =  panel.get_size()

func new_ball():
	while basketball_main_game.paus:
		
		if not is_inside_tree():
			return
			
		await get_tree().process_frame
		
		if not is_inside_tree():
			return
	
	deactivate_speed_boost()
	make_visible()
	
	position.x = win_size.x / 2 + 69
	position.y = win_size.y / 2 + 69
	speed = start_speed
	dir = random_direction()
	
func _physics_process(delta: float) -> void:
	var collision = move_and_collide(dir*speed*delta)	
	var collider
	
	if collision:
		collider = collision.get_collider()
		
		if abs(dir.x) < 0.2:
			dir.x = 0.5 if position.x < 500 else -0.5
			dir = dir.normalized()
		
		if collider == $"../Bpaddle1" or collider == $"../Bpaddle2":
			deactivate_speed_boost()
			make_visible()
			
			speed = min(speed + accel, max_speed)
			dir = new_direction(collider, collision)
			
			if "movement_dir" in collider and collider.movement_dir != 0:
				var p_speed = collider.get_parent().paddle_speed
				var momentum_transfer = p_speed * 0.25 # Adds 125 speed in movement direction
				
				var current_velocity = dir * speed
				current_velocity.y += momentum_transfer * collider.movement_dir
				
				dir = current_velocity.normalized()
				speed = min(current_velocity.length(), max_speed)
		else:
			dir = dir.bounce(collision.get_normal())
		
		var remainder = collision.get_remainder()
		if remainder.length() > 0.01:
			move_and_collide(dir * remainder.length())
			
		basketball_ball_sound.play()	
	
func random_direction():
	var new_dir := Vector2()
	new_dir.x = [1, -1].pick_random()
	new_dir.y = randi_range(-1, 1)
	return new_dir.normalized()

func new_direction(collider, collision):
	var ball_y = position.y
	var pad_y = collider.position.y
	var dist = clamp(ball_y - pad_y, -collider.p_height/2, collider.p_height/2)
	
	var new_dir = dir.bounce(collision.get_normal())
	new_dir.y += (dist / (collider.p_height / 2)) * max_y_vector
	
	return new_dir.normalized()
	
func activate_speed_boost() -> void:
	if not is_speed_boosted:
		is_speed_boosted = true
		speed *= 1.5
		
		


func deactivate_speed_boost() -> void:
	if is_speed_boosted:
		is_speed_boosted = false
		speed /= 1.5
		
		
		
func make_invisible():
	if not made_invisible:
		made_invisible = true
		
		$Basketball_Ball_Color.modulate.a = 0
		
func make_visible():
	if made_invisible:
		made_invisible = false
		
		$Basketball_Ball_Color.modulate.a = 1.0
