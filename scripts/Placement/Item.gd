extends Sprite2D

@onready var area_2d: Area2D = $Area2D
@onready var ok: ColorRect = $Ok
@onready var deny: ColorRect = $Deny
@onready var poleSoundPlay: AudioStreamPlayer2D = $PoleSoundPlay
@onready var poleConstruction: AudioStreamPlayer2D = $PoleConstruction

var layerOn

var pole_pos: Vector2i
var prev_pole_pos: Vector2i

func _process(delta):
	var mouse_tile: Vector2i = GameManager.tilemap.local_to_map(get_global_mouse_position())
	var local_pos: Vector2 = GameManager.tilemap.map_to_local(mouse_tile)
	var world_pos: Vector2 = GameManager.tilemap.to_global(local_pos)
	
	global_position = world_pos
	
	layerOn = GameManager.cityLayout[mouse_tile.x][mouse_tile.y + 1]
	pole_pos = mouse_tile
	GameManager.pole_position = Vector2i(mouse_tile.x, mouse_tile.y + 1)

	if (area_2d.get_overlapping_areas().size() > 0 ) || !(layerOn == GameManager.Layers.PAVEMENT):
		deny.show()
		ok.hide()
	else:
		var directions = [
			Vector2(-1, -1), Vector2(-1, 0), Vector2(-1, 1),  # Top-left, top, top-right
			Vector2(0, -1),                   Vector2(0, 1),  # Left,      right
			Vector2(1, -1), Vector2(1, 0), Vector2(1, 1)      # Bottom-left, bottom, bottom-right
		]
		
		# check pole proximity before placing
		if GameManager.isAdjacentCellsFilled(pole_pos.x, pole_pos.y + 1, directions, GameManager.Layers.Poles, GameManager.cityLayout):
			ok.hide()
			deny.show()
		else:
			ok.show()
			deny.hide()

func _unhandled_input(event):
	# place item
	if event is InputEventMouseButton && event.pressed && event.button_index == MOUSE_BUTTON_LEFT && GameManager.can_place_poles:
		var arr = area_2d.get_overlapping_areas()
		for obj in arr:
			obj.get_parent().queue_free()
		
		if !( (area_2d.get_overlapping_areas().size() > 0 ) || !(layerOn == GameManager.Layers.PAVEMENT) ):
			poleSoundPlay.play()
			poleSoundPlay.connect("finished", play_connect_sound)
			
			set_process(false)
			set_process_unhandled_input(false)
			
			area_2d.monitoring = false
			
			GameManager.cityLayout[pole_pos.x][pole_pos.y + 1] = GameManager.Layers.Poles
			GameManager.prev_pole_position = pole_pos
			GameManager.item_placed.emit()
		
		ok.hide()
		deny.hide()
	# unselect item
	if event is InputEventMouseButton && event.pressed && event.button_index == MOUSE_BUTTON_RIGHT:
		set_process(false)
		set_process_unhandled_input(false)
		area_2d.monitoring = false
		ok.hide()
		deny.hide()
		GameManager.emit_signal("item_unselected",self)
	
func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		GameManager.emit_signal("item_unselected",self)
		
func play_connect_sound():
	poleConstruction.play()

