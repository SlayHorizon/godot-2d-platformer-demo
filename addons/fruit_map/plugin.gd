@tool
extends EditorPlugin


const COLLECTIBLE: PackedScene = preload("res://source/maps/objects/collectible/collectible.tscn")
const GRID_STEP: Vector2 = Vector2(16, 16)

var last_fruit_button_selected: Button
var fruit_selection_interface: GridContainer

var selected_fruit_type_id: int
var selected_fruit_preview_texture: AtlasTexture


var selected_fruit_map: FruitMap


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	pass


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass


func _edit(object: Object) -> void:
	selected_fruit_map = object


func _handles(object: Object) -> bool:
	return object is FruitMap


func _make_visible(visible: bool) -> void:
	if visible:
		add_interface()
		EditorInterface.set_main_screen_editor("2D")
	else:
		remove_interface()


func _forward_canvas_draw_over_viewport(viewport_control: Control) -> void:
	if not selected_fruit_preview_texture or not selected_fruit_map:
		return
	var viewport_2d: SubViewport = EditorInterface.get_editor_viewport_2d()
	var scaling_factor: Vector2 = EditorInterface.get_editor_viewport_2d().global_canvas_transform.get_scale()
	var texture_size: Vector2 = selected_fruit_preview_texture.get_size() * scaling_factor
	var sclaled_step: Vector2 = GRID_STEP * scaling_factor
	var snapped_mouse_position = snapped_down((selected_fruit_map.get_global_mouse_position() * scaling_factor), sclaled_step)

	viewport_control.draw_texture_rect(
		selected_fruit_preview_texture,
		Rect2(
			(viewport_2d.global_canvas_transform.origin + snapped_mouse_position) - texture_size / 4,
			texture_size
		),
		false,
		Color.WHITE
	)
	viewport_control.draw_rect(
		Rect2(
			(viewport_2d.global_canvas_transform.origin + snapped_mouse_position),
			GRID_STEP * scaling_factor,
		),
		Color.ORANGE,
		false,
	)


func _forward_canvas_gui_input(event: InputEvent) -> bool:
	if not selected_fruit_map:
		return false
	
	if event is InputEventMouseMotion:
		# Redraw viewport when cursor is moved.
		update_overlays()
		return true
	
	if not event is InputEventMouseButton:
		return false
	if not event.pressed:
		return false 
	
	if event.button_index == MOUSE_BUTTON_LEFT:
		add_fruit_action()
	elif event.button_index == MOUSE_BUTTON_RIGHT:
		remove_fruit_action()
	
	EditorInterface.mark_scene_as_unsaved()
	EditorInterface.edit_node.call_deferred(selected_fruit_map)
	
	return true


func add_interface() -> void:
	if fruit_selection_interface:
		return
	fruit_selection_interface = GridContainer.new()
	fruit_selection_interface.columns = 2
	fruit_selection_interface.custom_minimum_size = EditorInterface.get_editor_viewport_2d().get_visible_rect().size * 0.2
	
	add_control_to_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_SIDE_RIGHT, fruit_selection_interface)

	for fruit_id: int in Fruit.Fruits.values():
		var fruit_texutre: Texture2D = Fruit.get_fruit_texture(Fruit.Fruits.keys()[fruit_id].capitalize())
		var fruit_preview: AtlasTexture = get_fruit_texture_preview(fruit_texutre)
		add_fruit_button(fruit_preview, fruit_id)
		
	if fruit_selection_interface.get_child_count():
		var fruit_button := fruit_selection_interface.get_child(0) as Button
		if fruit_button:
			fruit_button.button_pressed = true
			fruit_button.pressed.emit()


func remove_interface() -> void:
	if fruit_selection_interface:
		remove_control_from_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_SIDE_RIGHT, fruit_selection_interface)
		fruit_selection_interface.queue_free()
		fruit_selection_interface = null


func _on_fruit_selected(fruit_id: int, fruit_texture: Texture2D, button: Button) -> void:
	selected_fruit_type_id = fruit_id
	selected_fruit_preview_texture = fruit_texture
	if last_fruit_button_selected and is_instance_valid(last_fruit_button_selected):
		last_fruit_button_selected.button_pressed = false
	last_fruit_button_selected = button


func add_fruit_action() -> void:
	var new_fruit: Fruit = COLLECTIBLE.instantiate()
	new_fruit.fruit = selected_fruit_type_id
	
	var fruit_positon: Vector2 = snapped_down(selected_fruit_map.get_global_mouse_position(), GRID_STEP) + GRID_STEP / 2
	
	var undo_redo_manager: EditorUndoRedoManager = get_undo_redo()
	undo_redo_manager.create_action("add_fruit")
	undo_redo_manager.add_do_method(self, "do_add_fruit", new_fruit, fruit_positon)
	undo_redo_manager.add_undo_method(self, "undo_add_fruit", new_fruit)
	undo_redo_manager.add_do_reference(new_fruit)
	undo_redo_manager.commit_action()


func do_add_fruit(fruit: Fruit, fruit_position: Vector2) -> void:
	selected_fruit_map.add_child(fruit, true)
	fruit.global_position = fruit_position
	fruit.owner = EditorInterface.get_edited_scene_root()


func undo_add_fruit(fruit: Fruit) -> void:
	selected_fruit_map.remove_child(fruit)
	# No queue_free as we may redo action
	# add_do_reference() will take care of doing it if necessary


func remove_fruit_action() -> void:
	var viewport_2d: SubViewport = EditorInterface.get_editor_viewport_2d()
	var direct_space_state: PhysicsDirectSpaceState2D = viewport_2d.get_world_2d().direct_space_state
	var parameters := PhysicsPointQueryParameters2D.new()
	parameters.position = selected_fruit_map.get_global_mouse_position()
	parameters.collide_with_areas = true
	var result: Array[Dictionary] = direct_space_state.intersect_point(parameters)
	if not (
		result.size()
		and result[0].has("collider")
	):
		return
	
	# Will cast to null if the target isn't a Fruit
	var fruit: Fruit = result[0]["collider"] as Fruit
	
	if fruit and fruit.get_parent() == selected_fruit_map:
		var undo_redo_manager: EditorUndoRedoManager = get_undo_redo()
		undo_redo_manager.create_action("remove_fruit")
		undo_redo_manager.add_do_method(self, "do_remove_fruit", fruit)
		undo_redo_manager.add_undo_method(self, "undo_remove_fruit", fruit)
		undo_redo_manager.add_do_reference(fruit)
		undo_redo_manager.commit_action()


func do_remove_fruit(fruit: Fruit) -> void:
	selected_fruit_map.remove_child(fruit)


func undo_remove_fruit(fruit: Fruit) -> void:
	selected_fruit_map.add_child(fruit)
	fruit.owner = selected_fruit_map


func add_fruit_button(icon: Texture2D, fruit_id: int) -> void:
		var button := Button.new()
		button.toggle_mode = true
		button.icon = icon
		# Icon Behavior
		button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		button.vertical_icon_alignment = VERTICAL_ALIGNMENT_CENTER
		button.expand_icon = true
		# Layout
		button.custom_minimum_size = Vector2(32, 32) * 2
		button.size_flags_horizontal = Control.SIZE_FILL | Control.SIZE_EXPAND
		button.size_flags_vertical = Control.SIZE_FILL | Control.SIZE_EXPAND
		# Canvas Item -> Texture
		button.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		button.pressed.connect(_on_fruit_selected.bind(fruit_id, icon, button))
		
		fruit_selection_interface.add_child(button)


func get_fruit_texture_preview(fruit_texture: Texture2D) -> AtlasTexture:
	var atlas_texture := AtlasTexture.new()
	atlas_texture.atlas = fruit_texture
	atlas_texture.region.size = Vector2(32, 32)
	return atlas_texture


func snapped_down(position: Vector2, step: Vector2) -> Vector2:
	return (position / step).floor() * step
