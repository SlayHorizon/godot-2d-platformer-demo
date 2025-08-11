@icon("res://assets/node_icons/blue/icon_character.png")
@tool
class_name Character
extends CharacterBody2D


@export var character_resource: CharacterResource = preload("res://source/characters/resources/collection/ninja_frog.tres"):
	set = _set_character_resource

@onready var sprite: Sprite2D = $Sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animation_player.play(&"idle")


func _on_current_animation_changed(animation_name: String) -> void:
	_set_animation_texture(animation_name)


func _set_animation_texture(animation_name: String) -> void:
	if not is_node_ready():
		await ready
	var animation_texture = character_resource.get(animation_name + "_texture")
	if animation_texture != null:
		sprite.texture = animation_texture


func _set_character_resource(new_resource: CharacterResource) -> void:
	character_resource = new_resource
	if not is_node_ready():
		await ready
	_set_animation_texture(animation_player.current_animation)
