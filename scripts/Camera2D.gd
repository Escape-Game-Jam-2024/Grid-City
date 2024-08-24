extends Camera2D

@onready var tile_map = $"../TileMap"

func _ready():
	
	set_anchor_mode(Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT)
	
