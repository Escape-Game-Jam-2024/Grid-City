extends TileMap

@onready var node_2d:Node2D = $Node2D
@onready var gameSound: AudioStreamPlayer2D = $GameSound

var fill_grid_size = Vector2i(256, 256)
var grid_size: Vector2i

enum Layers {
	GROUND,
	GRASS,
	ROAD,
	PAVEMENT,
	HOUSE,
	Station,
	Poles,
	Wires
}

var city_layout: Array

var house_factor: int = 30

func _ready():
	if gameSound != null:
		pass
		#gameSound.play()
	GameManager.tilemap = self;
	
	grid_size = GameManager.grid_size
	
	city_layout = fill_grid_with_zeros()
	
	# TODO: add power station to map
	city_layout[2][6] = Layers.Station
	# city_layout[0][0] = Layers.Wires
	
	#self.set_cell(Layers.Wires, Vector2i(2, 5), 1, Vector2i(0, 1)) 
	
	generate_city_layout() 
	build_city()

func build_city():
	for x in range(fill_grid_size.x):
		for y in range(fill_grid_size.y):
			if city_layout[x][y] == Layers.GRASS:
				
				self.set_cell(Layers.GRASS, Vector2i(x, y), 0, Vector2i(5, 51)) 
			elif city_layout[x][y] == Layers.ROAD:
				
				self.set_cell(Layers.ROAD, Vector2i(x, y), 0, Vector2i(3, 38))
			elif city_layout[x][y] == Layers.PAVEMENT:
				
				self.set_cell(Layers.PAVEMENT, Vector2i(x, y), 0, Vector2i(21, 40))
			elif city_layout[x][y] == Layers.HOUSE:
		
				var directions = [
					Vector2(-1, -1), Vector2(-1, 0), Vector2(-1, 1),  # Top-left, top, top-right
					Vector2(0, -1),                   Vector2(0, 1),  # Left,      right
					Vector2(1, -1), Vector2(1, 0), Vector2(1, 1)      # Bottom-left, bottom, bottom-right
				]
				
				if !GameManager.isAdjacentCellsFilled(x, y, directions, Layers.ROAD, city_layout) and (x > 10 and y > 12):
					self.set_cell(Layers.HOUSE, Vector2i(x, y),0, Vector2i(18, 11))
				else:
					self.set_cell(Layers.GRASS, Vector2i(x, y), 0, Vector2i(5, 51)) 
			elif city_layout[x][y] == Layers.Station:
				
				self.set_cell(Layers.Station, Vector2i(x, y),0, Vector2i(17, 2))
			else:
				self.set_cell(Layers.GROUND, Vector2i(x, y),0, Vector2i(16, 50))

func generate_city_layout() -> void:
	
	generate_roads()
	generate_pavements()
	place_houses()
	fill_grass()
	GameManager.cityLayout = city_layout
	
func generate_roads():
	
	const limit = 2
	
	# main vertical roads
	for x in range(grid_size.x):
		city_layout[x][floor(grid_size.y / limit)] = Layers.ROAD
		city_layout[x][floor(grid_size.y / limit) + 1] = Layers.ROAD
		
		city_layout[x][0] = Layers.ROAD
		city_layout[x][1] = Layers.ROAD
		
	# main horizontal road
	for y in range(grid_size.y):
		city_layout[floor(grid_size.y / limit)][y] = Layers.ROAD
		city_layout[floor(grid_size.y / limit) + 1][y] = Layers.ROAD
	
	#var roads_determinant = 2
	#
	#for i in range(roads_determinant):
		#
		#var random_x = randi() % grid_size.x
		#var random_y = randi() % grid_size.y
		#
		#var prev_random_x 
		#var prev_random_y
		#
		#for x in range(grid_size.y):
			#city_layout[floor(random_y / limit)][x] = Layers.ROAD
		#
		#for y in range(grid_size.y):
			#city_layout[y][floor(random_x / limit)] = Layers.ROAD

func generate_pavements():
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			if city_layout[x][y] == Layers.ROAD:
				if y > 0 and city_layout[x][y - 1] == Layers.GROUND:
					city_layout[x][y - 1] = Layers.PAVEMENT
				if y < grid_size.y - 1 and city_layout[x][y + 1] == Layers.GROUND:
					city_layout[x][y + 1] = Layers.PAVEMENT
				if x > 0 and city_layout[x - 1][y] == Layers.GROUND:
					city_layout[x - 1][y] = Layers.PAVEMENT
				if x < grid_size.x - 1 and city_layout[x + 1][y] == Layers.GROUND:
					city_layout[x + 1][y] = Layers.PAVEMENT

func place_houses():
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			if city_layout[x][y] == Layers.PAVEMENT and !isNextToHouse(x, y):
				# Randomly place houses next to pavements
				if randi() % house_factor == 0:
					if y > 0 and city_layout[x][y - 2] == Layers.GROUND:
						city_layout[x][y - 2] = Layers.HOUSE
					if y < (grid_size.y - 2) and city_layout[x][y + 1] == Layers.GROUND:
						city_layout[x][y + 2] = Layers.HOUSE
					if x > 0 and city_layout[x - 2][y] == Layers.GROUND:
						city_layout[x - 2][y] = Layers.HOUSE
					if x < (grid_size.x - 2) and city_layout[x + 1][y] == Layers.GROUND:
						city_layout[x + 2][y] = Layers.HOUSE

func fill_grass():
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			if city_layout[x][y] == Layers.GROUND:
				city_layout[x][y] = Layers.GRASS

func isNextToHouse(x, y) -> bool:
	
	var directions = [
		Vector2(-2, -2), Vector2(-2, 1), Vector2(-2, 2),  # Top-left, top, top-right
		Vector2(1, -2),                   Vector2(1, 2),  # Left,      right
		Vector2(2, -2), Vector2(2, 1), Vector2(2, 2)      # Bottom-left, bottom, bottom-right
	]

	return GameManager.isAdjacentCellsFilled(x, y, directions, Layers.HOUSE, city_layout)


func fill_grid_with_zeros():
	var grid = [] 
	
	for x in range(fill_grid_size.x):
		var row: Array[int] = []
		for y in range(fill_grid_size.y):
			row.append(0)
		grid.append(row)
	
	return grid
	
func place_object(obj):
	node_2d.add_child(obj)

func remove_object(obj):
	obj.queue_free()
