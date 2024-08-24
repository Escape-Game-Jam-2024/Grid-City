extends Node

signal item_selected
var tilemap

func _ready():
	item_selected.connect(self.item_select)
	
func item_select(texture: Texture2D):
	var item = preload("res://scenes/Placement/Item.tscn").instantiate()
	item.texture = texture

	if texture.get_size().y > 16:
		item.offset.y = -16

	get_tree().call_group("tilemapGroup", "place_object", item)
