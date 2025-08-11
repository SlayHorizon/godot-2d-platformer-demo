@icon("res://assets/node_icons/blue/icon_camera_grid.png")
extends Camera2D


@export var grid_size: Vector2 = Vector2(640, 360)

var current_room := Vector2.ZERO


func _ready() -> void:
	current_room = ((get_global_position() - offset) / grid_size).round()
	Events.room_changed.connect(_on_room_changed)


func _on_room_changed(room_position: Vector2) -> void:
	# Update camera to the new room
	var room_target: Vector2 = ((room_position - offset) / grid_size).round()
	if room_target != current_room:
		current_room = room_target
		var tween: Tween = create_tween()
		tween.tween_property(self, ^"global_position", room_target * grid_size, 1.1)
