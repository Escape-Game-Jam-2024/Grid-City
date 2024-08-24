extends Node

enum Layers {
	GROUND,
	GRASS,
	ROAD,
	PAVEMENT,
	HOUSE,
}

signal item_selected
signal item_unselected
var tilemap: TileMap
var cityLayout: Array

func _ready():
	item_selected.connect(self.item_select)
	item_unselected.connect(self.item_unselect)
	
func item_select(texture: Texture2D):
	var item = preload("res://scenes/Placement/Item.tscn").instantiate()
	item.texture = texture

	if texture.get_size().y > 16:
		item.offset.y = -16

	get_tree().call_group("tilemapGroup", "place_object", item)
	
func item_unselect(item: Sprite2D):
	get_tree().call_group("tilemapGroup", "remove_object", item)
