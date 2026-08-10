extends Area2D

@export var freeze_duration: float = 2.0
@export var lifetime: float = 7.0
@onready var ice_sound: AudioStreamPlayer2D = $Ice_Sound

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

	if body.name == "Ball" :
		is_collected = true
		
		
		set_deferred("monitoring", false)
		hide()

		
		var parent_scene = get_parent()
		if body.dir.x > 0 and parent_scene.has_node("Paddle2"):
			parent_scene.get_node("Paddle2").freeze(freeze_duration)
		elif body.dir.x < 0 and parent_scene.has_node("Paddle1"):
			parent_scene.get_node("Paddle1").freeze(freeze_duration)

		
		ice_sound.play()
		await ice_sound.finished
		queue_free()
		
	elif body.name == "Football_Ball" :
		is_collected = true
		
		
		set_deferred("monitoring", false)
		hide()

		
		var parent_scene = get_parent()
		if body.dir.x > 0 and parent_scene.has_node("Fpaddle2"):
			parent_scene.get_node("Fpaddle2").freeze(freeze_duration)
		elif body.dir.x < 0 and parent_scene.has_node("Fpaddle1"):
			parent_scene.get_node("Fpaddle1").freeze(freeze_duration)

		
		ice_sound.play()
		await ice_sound.finished
		queue_free()
		
	elif body.name == "Basketball_Ball" :
		is_collected = true
		
		
		set_deferred("monitoring", false)
		hide()

		
		var parent_scene = get_parent()
		if body.dir.x > 0 and parent_scene.has_node("Bpaddle2"):
			parent_scene.get_node("Bpaddle2").freeze(freeze_duration)
		elif body.dir.x < 0 and parent_scene.has_node("Bpaddle1"):
			parent_scene.get_node("Bpaddle1").freeze(freeze_duration)

		
		ice_sound.play()
		await ice_sound.finished
		queue_free()
		
	elif body.name == "Voleyball_Ball" :
		is_collected = true
		
		
		set_deferred("monitoring", false)
		hide()

		
		var parent_scene = get_parent()
		if body.dir.x > 0 and parent_scene.has_node("Vpaddle2"):
			parent_scene.get_node("Vpaddle2").freeze(freeze_duration)
		elif body.dir.x < 0 and parent_scene.has_node("Vpaddle1"):
			parent_scene.get_node("Vpaddle1").freeze(freeze_duration)

		
		ice_sound.play()
		await ice_sound.finished
		queue_free()			
