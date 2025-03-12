@icon("res://assets/node_icons/white/icon_transition.png")
extends CanvasLayer


@onready var transition_effect_rect: ColorRect = $TransitionEffectRect


func _ready() -> void:
	transition_effect_rect.material.set("shader_parameter/progress", 1.0)
	await transition_effect()


func transition_effect() -> void:
	var tween := create_tween()
	tween.tween_property(
		transition_effect_rect,
		"material:shader_parameter/progress",
		0.0 if transition_effect_rect.material.get("shader_parameter/progress") == 1.0 else 1.0,
		1.2
	)
	await tween.finished
	Events.transition_finished.emit()
