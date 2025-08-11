@tool
class_name Fruit
extends Area2D


enum Fruits {
	APPLE,
	BANANAS,
	CHERRIES,
	KIWI,
	MELON,
	ORANGE,
	PINEAPPLE,
	STRAWBERRY,
}

@export var fruit: Fruits = Fruits.APPLE:
	set = _set_fruit

var collected: bool = false


func _ready() -> void:
	if not Engine.is_editor_hint():
		body_entered.connect(_on_body_entered)


func _set_fruit(value: Fruits) -> void:
	fruit = value
	set_fruit_texture(Fruits.keys()[fruit].capitalize())


static func get_fruit_texture(fruit_name: String) -> Texture2D:
	var fruit_texture: Texture2D = load(
		"res://assets/pixel-adventure/Items/Fruits/"
		+ fruit_name
		+ ".png"
	)
	return fruit_texture


func set_fruit_texture(fruit_name: String) -> void:
	if not is_node_ready():
		await ready
	$FruitSprite.texture = get_fruit_texture(fruit_name)


func _on_body_entered(body: Node2D) -> void:
	if body is Player and not collected:
		collected = true
		$AnimationPlayer.play("collected")
		Events.fruit_collected.emit()
		await $AnimationPlayer.animation_finished
		queue_free()
