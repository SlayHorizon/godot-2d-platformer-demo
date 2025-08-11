@tool
extends PlayerState


var wall_jump_velocity: float = 70.0
var slide_acceleration: float = 15.0
var friction_factor: float = 0.75
var max_slide_speed: float = 90.0


func enter() -> void:
	super.enter()


func state_process(delta: float) -> void:
	player.move()
	_apply_gravity(delta)
	if player.is_on_floor():
		player.states.Idle.enter()
	elif not player.is_on_wall():
		player.states.Fall.enter()
	elif Input.is_action_just_pressed("ui_up"):
		player.velocity.x = wall_jump_velocity * player.get_wall_normal().x
		player.states.Jump.enter()


func _apply_gravity(delta: float) -> void:
	if player.velocity.y > max_slide_speed:
		player.velocity.y = lerp(player.velocity.y, max_slide_speed, friction_factor)
	else:
		player.velocity.y += slide_acceleration * delta
	player.velocity.y = clampf(player.velocity.y, 0.0, max_slide_speed)
