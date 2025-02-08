extends Node


func _ready() -> void:
	DisplayServer.window_set_title("Pixel Adventure - Godot")


func _unhandled_key_input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_F11):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
