@tool
class_name BackgroundSprite
extends Sprite2D


enum Backgrounds {
	BLUE,
	BROWN,
	GRAY,
	GREEN,
	PINK,
	PURPLE,
	YELLOW,
}

# Create a dictionary to preload the textures
var background_textures: Dictionary = {
	Backgrounds.BLUE: preload("res://assets/pixel-adventure/Background/Blue.png"),
	Backgrounds.BROWN: preload("res://assets/pixel-adventure/Background/Brown.png"),
	Backgrounds.GRAY: preload("res://assets/pixel-adventure/Background/Gray.png"),
	Backgrounds.GREEN: preload("res://assets/pixel-adventure/Background/Green.png"),
	Backgrounds.PINK: preload("res://assets/pixel-adventure/Background/Pink.png"),
	Backgrounds.PURPLE: preload("res://assets/pixel-adventure/Background/Purple.png"),
	Backgrounds.YELLOW: preload("res://assets/pixel-adventure/Background/Yellow.png"),
}

@export var background_color: Backgrounds = Backgrounds.BLUE:
	set = _set_background_color


# Setter function to change the background texture based on selected color
func _set_background_color(new_background_color: Backgrounds) -> void:
	# Set the texture based on the enum value
	texture = background_textures.get(new_background_color, null)
	if texture == null:
		printerr("Error: Background texture not found!")
	background_color = new_background_color
