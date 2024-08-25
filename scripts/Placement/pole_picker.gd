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

func _on_pole_picked(_texture):
    poles_remaining -= 1

func _on_pole_removed(_texture):
    if poles_remaining == poles:
        return

    poles_remaining += 1

func _process(_delta):
    pole_count_label.text = '[center] %s' % poles_remaining
