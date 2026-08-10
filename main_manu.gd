extends Control

@onready var menu: VBoxContainer = $Menu
@onready var settings: Panel = $Settings
@onready var choice: Panel = $Choice
@onready var information: Panel = $Information
@onready var about: Button = $About


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	menu.visible = true
	about.visible = true
	settings.visible = false
	choice.visible = false
	information.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_play_pressed() -> void:
	menu.visible = false
	settings.visible = false
	about.visible = false
	choice.visible = true


func _on_settings_pressed() -> void:
	menu.visible = false
	about.visible = false
	settings.visible = true


func _on_back_pressed() -> void:
	_ready()


func _on_fullscreen_toggled(toggled_on: bool) -> void:
	pass # Replace with function body.


func _on_ai_pressed() -> void:
	Global.ai_mode = true
	
	match Global.selected_field:
		0:
			get_tree().change_scene_to_file("res://main_game.tscn")
		1:
			get_tree().change_scene_to_file("res://football_main_game.tscn")
		2:
			get_tree().change_scene_to_file("res://basketball_main_game.tscn")
		3:
			get_tree().change_scene_to_file("res://voleyball_main_game.tscn")	


func _on_multiplayer_pressed() -> void:
	Global.ai_mode = false
	
	match Global.selected_field:
		0:
			get_tree().change_scene_to_file("res://main_game.tscn")
		1:
			get_tree().change_scene_to_file("res://football_main_game.tscn")
		2:
			get_tree().change_scene_to_file("res://basketball_main_game.tscn")
		3:
			get_tree().change_scene_to_file("res://voleyball_main_game.tscn")

func _on_back_2_pressed() -> void:
	menu.visible = true
	settings.visible = false
	choice.visible = false


func _on_about_pressed() -> void:
	information.visible = true
	menu.visible = false
	about.visible = false


func _on_back_to_menu_2_pressed() -> void:
	_ready()
