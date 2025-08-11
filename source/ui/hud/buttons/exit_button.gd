extends CustomTextureButton


func _ready() -> void:
	if OS.has_feature("web"):
		# Can't quit on web so we hide this button to avoid issue
		hide()
		return
	# Call _ready on inherited class
	super()


func _on_pressed() -> void:
	disabled = true
	get_tree().quit()
