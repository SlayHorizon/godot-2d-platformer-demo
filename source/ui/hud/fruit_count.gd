extends Label


func _ready() -> void:
	Events.fruit_collected.connect(_on_fruit_collected)


func _on_fruit_collected() -> void:
	set_text(str(int(text) + 1))
