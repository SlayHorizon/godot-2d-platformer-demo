@tool
extends PlayerState


func enter() -> void:
	super.enter()


func state_process(delta: float) -> void:
	player.apply_gravity(delta)
	player.move()
	if player.is_on_floor():
		player.jump_buffer = true
		player.double_jump = true
		if player.velocity.is_zero_approx():
			player.states.Idle.enter()
		else:
			player.states.Run.enter()
	elif Input.is_action_just_pressed("ui_up"):
		if player.jump_buffer:
			player.states.Jump.enter()
		elif player.double_jump:
			player.states.DoubleJump.enter()
	elif player.is_on_wall_only():
		player.states.WallJump.enter()
