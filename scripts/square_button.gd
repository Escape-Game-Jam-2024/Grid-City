@tool
extends TextureButton

signal clicked

@export_file("*.png") var texture_file: String:
	set(new_value):
		texture_file = new_value

@onready var texture_rect: TextureRect = $MarginContainer/TextureRect


func _ready():
	button_down.connect(_on_button_pressed)
	button_up.connect(_on_button_released)

	pivot_offset = size / 2

func _process(_delta):
	if texture_file: texture_rect.texture = load(texture_file)
	else: texture_rect.texture = null

func _on_button_pressed():
	scale = Vector2(0.97, 0.97)

func _on_button_released():
	scale = Vector2(1, 1)
	clicked.emit()
