extends StaticBody2D

var win_height : int
var p_height : int
var is_frozen : bool = false
var movement_dir : int = 0

@onready var paddle_1_color: ColorRect = $Paddle1_Color
@onready var panel: Panel = $"../Background/Panel"
@onready var vpaddle_1_color: ColorRect = $Vpaddle1_Color


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	win_height = panel.get_size().y
	p_height = vpaddle_1_color.get_size().y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_frozen:
		return
	
	movement_dir = 0
	
	if not get_parent().paus :
		if Input.is_action_pressed("move_up"):
			position.y -= get_parent().paddle_speed * delta 
			
			movement_dir = -1
		elif Input.is_action_pressed("move_down"):
			position.y += get_parent().paddle_speed * delta 
			
			movement_dir = 1
	
	position.y = clamp(position.y, p_height / 2 + 69, win_height - p_height / 2 + 51)

func freeze(duration: float = 2.0) -> void:
	if is_frozen:
		return
		
	is_frozen = true
	
	
	
	vpaddle_1_color.color = Color("27F7FD")
	
	await get_tree().create_timer(duration).timeout
	
	
	vpaddle_1_color.color = Color("990000")
	is_frozen = false
	
