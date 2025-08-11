@icon("res://assets/node_icons/white/icon_audio.png")
extends AudioStreamPlayer


@export var play_in_editor: bool = false


func _ready() -> void:
	if OS.has_feature("editor") and not play_in_editor:
		playing = false
	Events.sound_button_pressed.connect(_on_sound_button_pressed)


func _on_sound_button_pressed() -> void:
	playing = not playing
