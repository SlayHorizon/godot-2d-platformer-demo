extends CustomTextureButton


func _ready() -> void:
	if OS.has_feature("web"):
		hide()


func _on_pressed() -> void:
	disabled = true
	print("get_tree().quit()")
	get_tree().quit()
