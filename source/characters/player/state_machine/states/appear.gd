@tool
extends PlayerState


func enter() -> void:
	super.enter()
	await player.animation_player.animation_finished
	player.states.Fall.enter()


func process(_delta: float) -> void:
	pass
