extends CheckButton

func _ready() -> void:
	
	button_pressed = Global.full_screen_mode
	
	
	if not toggled.is_connected(_on_toggled):
		toggled.connect(_on_toggled)
		
	
	apply_fullscreen(Global.full_screen_mode)

func _on_toggled(toggled_on: bool) -> void:
	apply_fullscreen(toggled_on)
	Global.full_screen_mode = toggled_on

func apply_fullscreen(is_fullscreen: bool) -> void:
	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
