extends Node2D


@export var bump_force: float = 650.0

var bump_direction := Vector2.UP

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	bump_direction = bump_direction.rotated(rotation).round()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	animated_sprite_2d.play(&"jump")
	body.velocity = bump_force * bump_direction
