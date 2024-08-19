@tool
extends TextureButton

signal clicked

@export var text: String:
	set(new_value):
		text = new_value

@onready var margin_container: MarginContainer = $MarginContainer
@onready var text_label: RichTextLabel = $MarginContainer/RichTextLabel

const min_size: Vector2 = Vector2(160, 85)

func _ready():
	button_down.connect(_on_button_pressed)
	button_up.connect(_on_button_released)

	pivot_offset = size / 2

func _process(_delta):
	text_label.text = '[center]' + text
	if margin_container.size > min_size:
		size.x = margin_container.size.x + 0.2 * margin_container.size.x
	else:
		size.x = margin_container.size.x

func _on_button_pressed():
	scale = Vector2(0.97, 0.97)

func _on_button_released():
	scale = Vector2(1, 1)
	clicked.emit()
