extends CustomTextureButton


func _on_pressed() -> void:
	Events.sound_button_pressed.emit()
