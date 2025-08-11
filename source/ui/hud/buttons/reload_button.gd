extends CustomTextureButton


func _on_pressed() -> void:
	disabled = true
	get_tree().reload_current_scene()
