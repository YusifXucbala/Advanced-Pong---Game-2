extends StaticBody2D

var has_changed : bool = false

@onready var right_wall: Area2D = $"../Right_Wall"

# Called when the node enters the scene tree for the first time.

func change_position(time : float = 4.0) -> void:
	if has_changed:
		return
		
	has_changed = true	
	
	position.y += 576
	right_wall.position.y -= 576
	
	await get_tree().create_timer(time).timeout
	
	position.y -= 576
	right_wall.position.y += 576
	
	has_changed = false
