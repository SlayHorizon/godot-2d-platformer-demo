@icon("res://assets/node_icons/blue/icon_camera_grid.png")
extends Camera2D


@export var grid_size := Vector2(640, 360)

var current_room := Vector2.ZERO


func _ready() -> void:
	current_room = ((get_global_position() - offset) / grid_size).round()
	Events.room_changed.connect(go_to_room)
	#go_to_room($"../Player".global_position)


func go_to_room(room_position: Vector2) -> void:
	var room_target: Vector2 = ((room_position - offset) / grid_size).round()
	if room_target != current_room:
		current_room = room_target
		var tween := create_tween()
		tween.tween_property(self, ^"global_position", room_target * grid_size, 1.1)
