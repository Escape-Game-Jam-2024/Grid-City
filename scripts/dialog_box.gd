@tool
extends Control

signal primary_button_clicked
signal secondary_button_clicked

@export var show_blur: bool:
	set(new_value):
		show_blur = new_value
@export var show_by_default: bool:
	set(new_value):
		show_by_default = new_value
@export var dialog_text: String:
	set(new_value):
		dialog_text = new_value
@export var primary_button_text: String:
	set(new_value):
		primary_button_text = new_value
@export var secondary_button_text: String:
	set(new_value):
		secondary_button_text = new_value
@export var dialog_box_size: Vector2:
	set(new_value):
		dialog_box_size = new_value

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var nine_patch_rect: NinePatchRect = $NinePatchRect
@onready var text_label: RichTextLabel = $NinePatchRect/MarginContainer/Main/DialogTop/DialogText
@onready var primary_button: Node = $NinePatchRect/MarginContainer/Main/DialogBottom/PrimaryButton
@onready var secondary_button: Node = $NinePatchRect/MarginContainer/Main/DialogBottom/SecondaryButton

var tween: Tween = null

func _ready():
	visible = show_by_default

	if Engine.is_editor_hint():
		visible = true

	visibility_changed.connect(_on_visibility_changed)
	primary_button.clicked.connect(_on_primary_button_clicked)
	secondary_button.clicked.connect(_on_secondary_button_clicked)

	nine_patch_rect.pivot_offset = nine_patch_rect.size / 2

func _on_visibility_changed():
	if Engine.is_editor_hint():
		return

	if visible:
		get_tree().paused = true
		
		if show_blur:
			animation_player.play('start_pause')
	else:
		get_tree().paused = false

func _on_primary_button_clicked():
	primary_button_clicked.emit()

func _on_secondary_button_clicked():
	secondary_button_clicked.emit()

func _process(_delta):
	nine_patch_rect.size = dialog_box_size

	nine_patch_rect.anchors_preset = Control.PRESET_CENTER

	text_label.text = '[center]' + dialog_text

	if primary_button_text:
		primary_button.text = primary_button_text
		primary_button.show()
	else:
		primary_button.hide()
	
	if secondary_button_text:
		secondary_button.text = secondary_button_text
		secondary_button.show()
	else:
		secondary_button.hide()
