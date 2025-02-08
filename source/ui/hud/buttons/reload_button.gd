extends CustomTextureButton


func _on_pressed() -> void:
	disabled = true
	print("get_tree().reload_current_scene()")
	get_tree().reload_current_scene()
