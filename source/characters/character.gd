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
	#sprite.texutre = character_resource.get(animation_name)
	match animation_name:
		"idle":
			sprite.texture = character_resource.idle_texture
		"run":
			sprite.texture = character_resource.run_texture
		"jump":
			sprite.texture = character_resource.jump_texture
		"double_jump":
			sprite.texture = character_resource.double_jump_texture
		"wall_jump":
			sprite.texture = character_resource.wall_jump_texture
		"fall":
			sprite.texture = character_resource.fall_texture
		"hit":
			sprite.texture = character_resource.hit_texture
		"appear":
			sprite.texture = character_resource.appear_texture
		"desappear":
			sprite.texture = character_resource.desappear_texture
		_:
			pass


func _set_character_resource(new_resource: CharacterResource) -> void:
	character_resource = new_resource
	if not is_node_ready():
		await ready
	_set_animation_texture(animation_player.current_animation)
