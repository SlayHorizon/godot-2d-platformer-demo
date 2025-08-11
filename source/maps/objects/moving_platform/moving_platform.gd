#@icon()
extends Path2D


enum PlatformMode {
	PLATFORM_MODE_MANUAL,
	PLATFORM_MODE_AUTO,
}

@export var speed: float = 35.0
@export var texture: Texture2D = preload("res://assets/pixel-adventure/Traps/Platforms/Chain.png")
@export var platforme_mode: PlatformMode = PlatformMode.PLATFORM_MODE_MANUAL

var reverse: bool = false
var has_player: bool = false
var callable_mode: Callable

@onready var path_follow_2d: PathFollow2D = $PathFollow2D
@onready var animatable_body_2d: AnimatableBody2D = $AnimatableBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatableBody2D/AnimatedSprite2D


func _ready() -> void:
	match platforme_mode:
		PlatformMode.PLATFORM_MODE_MANUAL:
			callable_mode = manual_mode
		PlatformMode.PLATFORM_MODE_AUTO:
			animated_sprite_2d.play(&"metal_platform")
			callable_mode = automatic_mode
	queue_redraw()


func _physics_process(delta: float) -> void:
	animatable_body_2d.position = path_follow_2d.position
	if callable_mode:
		callable_mode.call(delta)


func _draw() -> void:
	if not curve or not curve.point_count:
		return
	
	var texture_offset: Vector2 = texture.get_size() / 2
	var distance_between_textures: float = 8.0
	
	var total_length: float = curve.get_baked_length()
	var distance_traveled: float = 0.0
	while distance_traveled <= total_length:
		var point_position: Vector2 = curve.sample_baked(distance_traveled)
		draw_texture(texture, point_position - texture_offset)
		distance_traveled += distance_between_textures


func automatic_mode(delta: float) -> void:
	if path_follow_2d.progress_ratio < 1.0:
		if reverse:
			path_follow_2d.progress_ratio -= 0.2 * delta
		else:
			path_follow_2d.progress_ratio += 0.2 * delta
		if is_equal_approx(path_follow_2d.progress_ratio, 1.0):
			reverse = true
		elif is_equal_approx(path_follow_2d.progress_ratio, 0.0):
			reverse = false


func manual_mode(delta: float) -> void:
	if not has_player:
		path_follow_2d.progress -= speed * delta
	else:
		path_follow_2d.progress += speed * delta
	if path_follow_2d.progress >= 1.0:
		reverse = true
	elif path_follow_2d.progress <= 0.0:
		reverse = false
	if path_follow_2d.progress not in [0.0, 1.0]:
		animated_sprite_2d.play(&"wood_platform")
	else:
		animated_sprite_2d.stop()


func _on_player_detection_area_body_entered(body: Node2D) -> void:
	if body is Player and platforme_mode == PlatformMode.PLATFORM_MODE_MANUAL:
		has_player = true


func _on_player_detection_area_body_exited(body: Node2D) -> void:
	if body is Player and platforme_mode == PlatformMode.PLATFORM_MODE_MANUAL:
		has_player = false
