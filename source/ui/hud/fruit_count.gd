extends Label


func _ready() -> void:
	Events.fruit_collected.connect(
		func() -> void:
			text = str(int(text) + 1)
	)
