@tool
extends PlayerState


func enter() -> void:
	super.enter()
	player.jump_buffer = false
	player.velocity.y = player.jump_velocity


func state_process(delta: float) -> void:
	player.apply_gravity(delta)
	player.move()
	if player.is_on_floor():
		player.states.Idle.enter()
	elif player.double_jump and Input.is_action_just_pressed("ui_up"):
		player.states.DoubleJump.enter()
	elif player.velocity.y > 0:
		player.states.Fall.enter()
