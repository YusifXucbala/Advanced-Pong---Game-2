extends CharacterBody2D

@export var speed: float = 400.0
var dir: Vector2 = Vector2.RIGHT

func _ready() -> void:
	
	for paddle in get_tree().get_nodes_in_group("Paddles"):
		add_collision_exception_with(paddle)

func _physics_process(delta: float) -> void:
	
	if dir == Vector2.ZERO:
		dir = Vector2.RIGHT

	
	var collision = move_and_collide(dir * speed * delta)
	if collision:
		dir = dir.bounce(collision.get_normal())
		
	
	if global_position.x < -200 or global_position.x > 2000:
		queue_free()
