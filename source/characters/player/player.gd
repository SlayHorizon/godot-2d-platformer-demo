@tool
class_name Player
extends Character


# Tile IDs the player can pass through.
const ALLOWED_PASS_THROUGH: Array[Vector2i] = [
	Vector2i(17, 0), Vector2i(18, 0), Vector2i(19, 0),
	Vector2i(17, 1), Vector2i(18, 1), Vector2i(19, 1),
	Vector2i(17, 2), Vector2i(18, 2), Vector2i(19, 2),
]

var states: Dictionary[StringName, PlayerState]


var speed: float = 105.0
var acceleration: float = 630.0
var jump_velocity: float = -310.0
var gravity := Vector2(0, 980)


var input_direction := Vector2.ZERO

var jump_buffer: bool = true
var double_jump: bool = true

var state_callback: Callable

@onready var ray_cast: RayCast2D = $RayCast2D


func _ready() -> void:
	if Engine.is_editor_hint():
		set_physics_process(false)
		return
	
	for state: PlayerState in $States.get_children():
		state.animation_player = animation_player
		state.player = self
		states.set(state.name, state)
	
	states.Appear.enter()


func _physics_process(delta: float) -> void:
	if state_callback:
		state_callback.call(delta)
	
	input_direction = _get_input_direction()
	_set_sprite_direction()
	move_and_slide()


func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += gravity * delta


func move() -> void:
	velocity.x = move_toward(
		velocity.x, input_direction.x * speed,
		acceleration * get_physics_process_delta_time()
	)


func _set_sprite_direction() -> void:
	if input_direction.x:
		sprite.flip_h = input_direction.x == -1


func _get_input_direction() -> Vector2:
	return(
		Input.get_vector("ui_left", "ui_right", "ui_down", "ui_up")
	)
