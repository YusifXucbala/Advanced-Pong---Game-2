extends Area2D

@export var shield_duration: float = 4.0
@export var lifetime: float = 7.0
@onready var shield_sound: AudioStreamPlayer2D = $Shield_sound

var is_collected: bool = false

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

	if body.name == "Ball" or body.name == "Football_Ball" or body.name == "Basketball_Ball" or body.name == "Voleyball_Ball":
		is_collected = true
		
		
		set_deferred("monitoring", false)
		hide()

		
		var parent_scene = get_parent()
		if body.dir.x > 0 and parent_scene.has_node("Left_Block"):
			parent_scene.get_node("Left_Block").change_position(shield_duration)
		elif body.dir.x < 0 and parent_scene.has_node("Right_Block"):
			parent_scene.get_node("Right_Block").change_position(shield_duration)

	
		shield_sound.play()
		await shield_sound.finished
		queue_free()
