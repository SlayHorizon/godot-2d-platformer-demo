@icon("res://assets/node_icons/white/icon_transition.png")
extends CanvasLayer


@onready var transition_effect_rect: ColorRect = $TransitionEffectRect


func _ready() -> void:
	transition_effect_rect.material.set(
		&"shader_parameter/progress", 1.0
	)
	transition_effect()


func transition_effect() -> void:
	var shader_progress_target: float = 1.0
	if transition_effect_rect.material.get(&"shader_parameter/progress") == 1.0:
		shader_progress_target = 0.0
	
	var tween: Tween = create_tween()
	tween.tween_property(
		transition_effect_rect,
		^"material:shader_parameter/progress",
		shader_progress_target,
		1.2
	)
	# Emit 'Events.transition_finished' once the tween animation ends (one-shot).
	tween.finished.connect(Events.transition_finished.emit, ConnectFlags.CONNECT_ONE_SHOT)
