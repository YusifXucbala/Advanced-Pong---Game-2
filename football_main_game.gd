extends Node2D

@export var item_scenes: Array[PackedScene]
@export var spawn_min: Vector2 = Vector2(-350, -200)
@export var spawn_max: Vector2 = Vector2(350, 200)

@onready var spawn_timer: Timer = $SpawnTimer
@onready var panel: Panel = $Background/Panel
@onready var pausing: Panel = $Background/Pausing
@onready var final_part: Panel = $Background/Final_Part
@onready var label: Label = $Background/Final_Part/Label
@onready var left_block: StaticBody2D = $Left_Block
@onready var ball_timer: Timer = $Football_Ball_Timer

@onready var getting_point: AudioStreamPlayer2D = $Getting_Point
@onready var losing_point: AudioStreamPlayer2D = $Losing_Point
@onready var win: AudioStreamPlayer2D = $Win
@onready var lose: AudioStreamPlayer2D = $Lose


var score = [0, 0]
var speed_of_ball: float = 400.0
const paddle_speed: int = 500
var paus = false

func _ready() -> void:
	pausing.visible = false
	final_part.visible = false
	
	$Scores/Score1.text = "0"
	$Scores/Score2.text = "0"
	
	if not spawn_timer.timeout.is_connected(_on_spawn_timer_timeout):
		spawn_timer.timeout.connect(_on_spawn_timer_timeout)

	
	if not ball_timer.timeout.is_connected(_on_football_ball_timer_timeout):
		ball_timer.timeout.connect(_on_football_ball_timer_timeout)

func _on_spawn_timer_timeout() -> void:
	if paus or item_scenes.is_empty():
		return

	var selected_scene: PackedScene = item_scenes.pick_random()
	if selected_scene == null:
		return

	var selected_instance = selected_scene.instantiate()
	var random_x = randf_range(spawn_min.x, spawn_max.x)
	var random_y = randf_range(spawn_min.y, spawn_max.y)
	
	selected_instance.add_to_group("Items")
	selected_instance.position = Vector2(random_x, random_y)
	add_child(selected_instance)

# --- PAUSE SYSTEM ---

func _on_pause_pressed() -> void:
	pausing.visible = true
	paus = true
	
	if $Football_Ball.speed > 0:
		speed_of_ball = $Football_Ball.speed
	$Football_Ball.speed = 0
	
	spawn_timer.paused = true

func _on_resume_pressed() -> void:
	paus = false
	pausing.visible = false
	$Football_Ball.speed = speed_of_ball
	spawn_timer.paused = false

# --- GAME RESTART / RESET ---

func _on_restart_pressed() -> void:
	reset_game_state()

func reset_game_state() -> void:
	score = [0, 0]
	paus = false
	spawn_timer.paused = false
	final_part.visible = false
	pausing.visible = false
	
	$Scores/Score1.text = "0"
	$Scores/Score2.text = "0"
	
	get_tree().call_group("Items", "queue_free")
	
	if speed_of_ball > 0:
		$Football_Ball.speed = speed_of_ball
	$Football_Ball.new_ball()

# --- GOAL DETECTORS ---

func _on_left_wall_body_entered(body: Node2D) -> void:
	# Fixed: checks for Football_Ball instead of Ball
	if body.name == "Football_Ball":
		score[1] += 1
		$Scores/Score2.text = str(score[1])
		
		if Global.ai_mode:
			losing_point.play()
		else:
			getting_point.play()
		
		if score[1] >= 10:
			trigger_win(Global.ai_mode, "AI won. \nDo you want to play again?", "Player - 2 won.\n Do you want to play again?")
			
			if Global.ai_mode:
				lose.play()
			else:
				win.play()
		else:
			$Football_Ball_Timer.start() # Fixed typo in node path

func _on_right_wall_body_entered(body: Node2D) -> void:
	# Fixed: checks for Football_Ball instead of Ball
	if body.name == "Football_Ball":
		score[0] += 1
		$Scores/Score1.text = str(score[0])
		
		getting_point.play()
		
		if score[0] >= 10:
			trigger_win(Global.ai_mode, "You won. Congratulations!\n Do you want to play again?", "Player - 1 won.\n Do you want to play again?")
			
			win.play()
		elif not paus:
			$Football_Ball_Timer.start()

func trigger_win(is_ai: bool, ai_text: String, p2_text: String) -> void:
	paus = true
	spawn_timer.paused = true
	final_part.visible = true
	if $Football_Ball.speed > 0:
		speed_of_ball = $Football_Ball.speed
	$Football_Ball.speed = 0 # Fixed typo ($Football_Ball)
	label.text = ai_text if is_ai else p2_text

# --- BUTTON HANDLERS ---

func _on_back_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _on_back_to_menu_2_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _on_again_multiplayer_pressed() -> void:
	Global.ai_mode = false
	reset_game_state()

func _on_again_ai_pressed() -> void:
	Global.ai_mode = true
	reset_game_state()

func _on_football_ball_timer_timeout() -> void:
	$Football_Ball.new_ball()
