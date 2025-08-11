class_name CustomTextureButton
extends TextureButton


@export var scale_up_effect: Vector2 = Vector2(1.1, 1.1)
@export var effect_duration: float = 0.18


func _ready() -> void:
	pivot_offset = size * 0.5
	mouse_entered.connect(_on_button_mouse_entered)
	mouse_exited.connect(_on_button_mouse_exited)


func _on_button_mouse_entered() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, ^"scale", scale_up_effect, effect_duration).from(Vector2.ONE)


func _on_button_mouse_exited() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, ^"scale", Vector2.ONE, effect_duration)
