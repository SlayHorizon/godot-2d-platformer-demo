@icon("res://assets/node_icons/color/icon_map_colored.png")
class_name Map
extends Node2D


#var spawn_point: Vector2

@onready var player: Player = $Player
@onready var background_layer: TileMapLayer = $BackgroundLayer


#func _ready() -> void:
	#spawn_point = player.global_position
	#var tile_size := background_layer.tile_set.tile_size
	#$MapCamera.global_position = background_layer.get_used_rect().get_center() * tile_size + tile_size / 2
