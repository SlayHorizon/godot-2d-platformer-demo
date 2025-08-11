extends Node


@onready var window: Window = get_window()


func _ready() -> void:
	window.set_title("Pixel Adventure - Godot")


func _unhandled_key_input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_F11):
		if window.get_mode() == window.MODE_FULLSCREEN:
			window.set_mode(Window.MODE_WINDOWED)
		else:
			window.set_mode(Window.MODE_FULLSCREEN)
