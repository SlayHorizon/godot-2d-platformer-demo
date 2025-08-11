@tool
extends PlayerState


func enter() -> void:
	super.enter()
	
	player.jump_buffer = true
	player.double_jump = true


func state_process(delta: float) -> void:
	player.apply_gravity(delta)
	
	if player.velocity.y > 0:
		player.states.Fall.enter()
	elif player.input_direction.x:
		player.states.Run.enter()
	elif player.input_direction.y:
		if player.input_direction.y > 0 and player.is_on_floor():
			player.states.Jump.enter()
		else:
			var target: Object = player.ray_cast.get_collider()
			var collision_point: Vector2 = player.ray_cast.get_collision_point()
			if target is TileMapLayer:
				var local_position: Vector2 = target.to_local(collision_point)
				var map_coords: Vector2i = target.local_to_map(local_position)
				var atlas_coords: Vector2i = target.get_cell_atlas_coords(map_coords)
				if atlas_coords in player.ALLOWED_PASS_THROUGH:
					player.global_position.y += 3
