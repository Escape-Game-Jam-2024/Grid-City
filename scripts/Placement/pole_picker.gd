@tool
extends PanelContainer

@export var poles: int:
	set(new_value):
		poles = new_value

@onready var pole_count_label = $VBoxContainer/PoleCount

signal game_ui_ready

var poles_remaining: int

func _ready():
	GameManager.item_selected.connect(_on_pole_picked)
	GameManager.item_unselected.connect(_on_pole_removed)
	GameManager.item_placed.connect(_on_pole_placed)

	game_ui_ready.connect(_on_game_ui_ready)

func _on_game_ui_ready(number_of_poles: int):
	poles = number_of_poles
	poles_remaining = poles

func _on_pole_placed():
	if poles_remaining == 0:
		GameManager.pole_limit_exceeded.emit()
		return
	
	var layout = GameManager.cityLayout
	var pos: Vector2i = GameManager.pole_position

	var wire_pos = Vector2i(GameManager.pole_position.x, GameManager.pole_position.y + 1)
	
	print('curr: ', pos, 'point: ', layout[pos.x][pos.y])
	
	var directions = [
		Vector2(-1, -1), Vector2(-1, 0), Vector2(-1, 1),  # Top-left, top, top-right
		Vector2(0, -1),                   Vector2(0, 1),  # Left,      right
		Vector2(1, -1), Vector2(1, 0), Vector2(1, 1)      # Bottom-left, bottom, bottom-right
	]
	
	if GameManager.isAdjacentCellsFilled(pos.x, pos.y + 1, directions, GameManager.Layers.Poles, layout):
		print('abc: ', layout[pos.x - 2][pos.y])
		if layout[pos.x - 2][pos.y] == GameManager.Layers.Poles:
			wire_pos = Vector2i(pos.x - 1, pos.y) 
			GameManager.tilemap.set_cell(GameManager.Layers.Wires, wire_pos, 1, Vector2i(0, 1))
		elif layout[pos.x + 2][pos.y] == GameManager.Layers.Poles:
			wire_pos = Vector2i(pos.x + 1, pos.y) 
			GameManager.tilemap.set_cell(GameManager.Layers.Wires, wire_pos, 1, Vector2i(0, 1))
		elif layout[pos.x][pos.y - 2] == GameManager.Layers.Poles:
			wire_pos = Vector2i(pos.x, pos.y - 1)
			GameManager.tilemap.set_cell(GameManager.Layers.Wires, wire_pos, 1, Vector2i(1, 9))
		elif layout[pos.x][pos.y  + 2] == GameManager.Layers.Poles:
			wire_pos = Vector2i(pos.x, pos.y + 1) 			
			GameManager.tilemap.set_cell(GameManager.Layers.Wires, wire_pos, 1, Vector2i(1, 9))			

func _on_pole_picked(_texture):
	poles_remaining -= 1

func _on_pole_removed(_texture):
	if poles_remaining == poles:
		return

	poles_remaining += 1

func _process(_delta):
	pole_count_label.text = '[center] %s' % poles_remaining
