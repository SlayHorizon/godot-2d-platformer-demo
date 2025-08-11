@tool
extends PlayerState


func enter() -> void:
	super.enter()


func state_process(delta: float) -> void:
	player.apply_gravity(delta)
	player.move()
	if player.velocity.y > 0:
		player.states.Fall.enter()
	elif player.velocity.is_zero_approx():
		player.states.Idle.enter()
	elif player.input_direction.y > 0 and player.is_on_floor():
			player.states.Jump.enter()
