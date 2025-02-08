@tool
@icon("res://assets/node_icons/blue/icon_color_correction.png")
extends TileMapLayer


var background_color: String = "Blue":
	set = _set_background_color


func _ready() -> void:
	pass


func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	properties.append(
		{
			"name": "background_color",
			"type": TYPE_STRING_NAME,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": ",".join(get_background_colors()),
			
		}
	)
	return properties


func _property_get_revert(property: StringName) -> Variant:
	match property:
		&"background_color":
			return "blue"
	return null


func get_background_colors() -> PackedStringArray:
	var colors := PackedStringArray()
	for source_index: int in tile_set.get_source_count():
		var source_id: int = tile_set.get_source_id(source_index)
		var source: TileSetAtlasSource = tile_set.get_source(source_id)
		colors.append(source.resource_name)
	return colors


func replace_all_tiles_by(source_id: int, atlas_coords: Vector2i = Vector2i.ZERO) -> void:
	for cell_position: Vector2i in get_used_cells():
		set_cell(cell_position, source_id, atlas_coords)


func _set_background_color(new_color: String) -> void:
	background_color = new_color
	for source_index: int in tile_set.get_source_count():
		var source_id: int = tile_set.get_source_id(source_index)
		var source: TileSetAtlasSource = tile_set.get_source(source_id)
		if source.resource_name == new_color:
			replace_all_tiles_by(source_id)
			return
