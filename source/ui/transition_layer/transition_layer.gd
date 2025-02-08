@icon("res://assets/node_icons/white/icon_transition.png")
extends CanvasLayer



func _ready() -> void:
	$TransitionEffect.material.set("shader_parameter/progress", 1.0)
	await transition_effect()


func transition_effect() -> void:
	var color_rect: ColorRect = $TransitionEffect
	var tween := create_tween()
	tween.tween_property(
		color_rect,
		"material:shader_parameter/progress",
		0.0 if color_rect.material.get("shader_parameter/progress") == 1.0 else 1.0,
		1.2
	)
	await tween.finished
	Events.transition_finished.emit()
