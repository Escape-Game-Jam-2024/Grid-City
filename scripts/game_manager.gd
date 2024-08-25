extends Node

enum Layers {
	GROUND,
	GRASS,
	ROAD,
	PAVEMENT,
	HOUSE,
	Station,
	Wires,
	Poles,
}

var level_results: Dictionary = {}
var current_level: int = 1
var selected_level: int = 1
var last_level_played: int

signal item_selected
signal item_unselected
signal item_placed
signal pole_limit_exceeded
signal level_selected
signal play_clicked

var tilemap: TileMap
var cityLayout: Array
var can_place_poles: bool = true
var is_level_select: bool = false
var is_play_click: bool = false

var grid_size = Vector2i(118, 64)

var directions = [
	Vector2(-2, -2), Vector2(-2, 1), Vector2(-2, 2),  # Top-left, top, top-right
	Vector2(1, -2),                   Vector2(1, 2),  # Left,      right
	Vector2(2, -2), Vector2(2, 1), Vector2(2, 2)      # Bottom-left, bottom, bottom-right
]

var pole_position: Vector2i
var prev_pole_position: Vector2i

func _ready():
	item_selected.connect(self.item_select)
	item_unselected.connect(self.item_unselect)
	pole_limit_exceeded.connect(self._on_pole_limit_exceeded)
	level_selected.connect(self._on_level_selected)
	play_clicked.connect(self._on_play_clicked)

func _on_level_selected(level: int):
	selected_level = level
	is_level_select = true
	is_play_click = false

func _on_play_clicked():
	is_play_click = true
	is_level_select = false

func item_select(texture: Texture2D):
	var item = preload("res://scenes/Placement/Item.tscn").instantiate()
	item.texture = texture

	if texture.get_size().y > 16:
		item.offset.y = -16

	get_tree().call_group("tilemapGroup", "place_object", item)
	
func item_unselect(item: Sprite2D):
	get_tree().call_group("tilemapGroup", "remove_object", item)
	can_place_poles = true

func _on_pole_limit_exceeded():
	can_place_poles = false

func commit_level_results(level: int, level_finished: bool, time_elasped: float, poles_used: int):
	# TODO: Score calculation logic
	var stars = 0
	var score = 5
	
	level_results[level] = { "score": score, "stars": stars }

	if level == current_level and stars > 0:
		current_level += 1
	
	last_level_played = level

func isAdjacentCellsFilled(x, y, directions, layer, layout, grid_size = grid_size) -> bool:
	
	for dir in directions:
		var neighbor_x = x + dir.x
		var neighbor_y = y + dir.y
		
		# Check if the new position is within the grid bounds
		if (neighbor_x >= 0 and neighbor_x < grid_size.x) and (neighbor_y >= 0 and neighbor_y < grid_size.y):
			var city_point = layout[neighbor_x][neighbor_y] 
			if  city_point >= layer:
				print('found: ', city_point)
				return true
		
	return false
