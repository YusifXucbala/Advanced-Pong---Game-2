extends Control

@onready var option_button: OptionButton = $"."


func _ready() -> void:
	if option_button != null:
		option_button.select(Global.selected_field)
		if not option_button.item_selected.is_connected(_on_option_button_item_selected):
			option_button.item_selected.connect(_on_option_button_item_selected)

func _on_option_button_item_selected(index: int) -> void:
	Global.selected_field = index
