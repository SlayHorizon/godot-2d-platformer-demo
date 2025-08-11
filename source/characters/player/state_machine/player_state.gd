@tool
class_name PlayerState
extends Node


@export_group("Default Configuration")
@export var player: Player
@export var animation_player: AnimationPlayer

@export_group("")
var state_animation_name: StringName = &"idle"


func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	if animation_player:
		properties.append(
			{
				"name": "state_animation_name",
				"type": TYPE_STRING_NAME,
				"hint": PROPERTY_HINT_ENUM,
				"hint_string": ",".join(animation_player.get_animation_list()),
			}
		)
	return properties


func _property_get_revert(property: StringName) -> Variant:
	match property:
		&"state_animation_name":
			if animation_player:
				return StringName(animation_player.assigned_animation)
			return &"idle"
	return null


# To override
func enter() -> void:
	player.state_callback = state_process
	animation_player.play(state_animation_name)


# To override
func state_process(_delta: float) -> void:
	pass


# To override
func exit(player_state: PlayerState) -> void:
	player.state_callback = Callable()
	player_state.enter()
