extends StaticBody2D

var win_height : int
var p_height : int
var ball_post : Vector2
var dist : int
var move_by : int
var is_frozen : bool = false
var movement_dir : int = 0

@onready var panel: Panel = $"../Background/Panel"
@onready var paddle_2_color: ColorRect = $Paddle2_Color
@onready var basketball_ball: CharacterBody2D = $"../Basketball_Ball"
@onready var bpaddle_2_color: ColorRect = $Bpaddle2_Color




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	win_height = panel.get_size().y
	p_height = bpaddle_2_color.get_size().y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_frozen:
		return
	
	movement_dir = 0
	
	ball_post = $"../Basketball_Ball".position
	dist = position.y - ball_post.y
	
	if not get_parent().paus:
		if not Global.ai_mode:
			if Input.is_action_pressed("ui_up"):
				position.y -= get_parent().paddle_speed * delta 
				
				movement_dir = -1
			elif Input.is_action_pressed("ui_down"):
				position.y += get_parent().paddle_speed * delta
				
				movement_dir = 1 
		elif not basketball_ball.made_invisible:
			if abs(dist) > (get_parent().paddle_speed) * delta:
				move_by = (get_parent().paddle_speed) *  delta * (dist / abs(dist))
			else:
				move_by = dist
		
			if $"../Basketball_Ball".dir.x > 0:
				position.y -= move_by
				
				if move_by > 0:
					movement_dir = -1
				elif move_by < 0:
					movement_dir = 1
	
	position.y = clamp(position.y, p_height / 2 + 69, win_height - p_height / 2 + 59)
	
func freeze(duration: float = 2.0) -> void:
	if is_frozen:
		return
		
	is_frozen = true
	
	
	
	bpaddle_2_color.color = Color("26F7FD")
	
	await get_tree().create_timer(duration).timeout
	
	
	bpaddle_2_color.color = Color("6e0051")
	is_frozen = false
	
