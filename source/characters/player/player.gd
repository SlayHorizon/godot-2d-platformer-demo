@tool
class_name Player
extends Character


## Tile IDs the player can pass through.
## Tile IDs are "atlas coords" shown in TileSet panel when you select a tile.
const ALLOWED_PASS_THROUGH: Array[Vector2i] = [
	Vector2i(17, 0), Vector2i(18, 0), Vector2i(19, 0),
	Vector2i(17, 1), Vector2i(18, 1), Vector2i(19, 1),
	Vector2i(17, 2), Vector2i(18, 2), Vector2i(19, 2),
]

## States are auto-filled from the children of the $States node.
## To add a new state, add a derived PlayerState node as a child of $States.
## You can duplicate an existing PlayerState script as a starting point.
var states: Dictionary[StringName, PlayerState]

var speed: float = 105.0
var acceleration: float = 630.0
var jump_velocity: float = -310.0
var gravity: Vector2 = Vector2(0, 980)

var input_direction: Vector2 = Vector2.ZERO

var jump_buffer: bool = true
var double_jump: bool = true

var state_callback: Callable

@onready var ray_cast: RayCast2D = $RayCast2D


func _ready() -> void:
	if Engine.is_editor_hint():
		set_physics_process(false)
		return
	
	# Fill the 'states' dictionary from child nodes under $States.
	for state: PlayerState in $States.get_children():
		state.animation_player = animation_player
		state.player = self
		states.set(state.name, state)
	
	# How to enter the initial state:
	# Safe version:
	# if "Appear" in states:
	#     states["Appear"].enter()
	#
	# Direct version (works if you're sure the state exists):
	# states.Appear.enter()
	
	# Optional: delay the initial appearance until the screen
	# transition animation has finished.
	# (Remove this block if you want the player visible right away.)
	
	# Simple shortcut for this demo to check if we're in the main scene.
	if not get_tree().current_scene.name == "Main":
		return 
	hide() # Hide the player until the transition is done.
	Events.transition_finished.connect(
		func():
			show() # Show the player once the transition finishes.
			states.Appear.enter() # Then enter the initial state.
	)


func _physics_process(delta: float) -> void:
	input_direction = _get_input_direction()
	_set_sprite_direction()
	
	if state_callback:
		state_callback.call(delta)
	
	move_and_slide()


func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += gravity * delta


## Mainly used by the PlayerState nodes.
## 'velocity' is applied thanks to 'move_and_slide()' used in `_physics_process()`.
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
