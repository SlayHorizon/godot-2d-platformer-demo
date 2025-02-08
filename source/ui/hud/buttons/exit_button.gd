extends CustomTextureButton


func _on_pressed() -> void:
	disabled = true
	print("get_tree().quit()")
	get_tree().quit()
