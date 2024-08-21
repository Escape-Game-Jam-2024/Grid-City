extends TileMap

# Define the size of each tile
var grid_size = Vector2i(64, 64)

enum Layers {
	GROUND,
	GRASS,
	ROAD,
	PAVEMENT,
	HOUSE,
}

var city_layout: Array

func _ready():
	
	city_layout = fill_grid_with_zeros()
	
	generate_city_layout() 
	build_city()

func build_city():
	
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			if city_layout[x][y] == Layers.GRASS:
				self.set_cell(0, Vector2i(x, y), 0, Vector2i(5, 51))
			elif city_layout[x][y] == Layers.ROAD:
				self.set_cell(0, Vector2i(x, y), 0, Vector2i(3, 38))
			elif city_layout[x][y] == Layers.PAVEMENT:
				self.set_cell(0, Vector2i(x, y), 0, Vector2i(21, 40))
			elif city_layout[x][y] == Layers.HOUSE:
				self.set_cell(0, Vector2i(x, y),0, Vector2i(32, 3))
			else:
				self.set_cell(0, Vector2i(x, y),0, Vector2i(16, 50))

func generate_city_layout() -> void:
	
	generate_roads()
	generate_pavements()
	place_houses()
	fill_grass()

func generate_roads():
	
	# main vertical road
	for y in range(grid_size.y):
		city_layout[y][floor(grid_size.x / 3)] = Layers.ROAD
	
	# main horizontal road
	for x in range(grid_size.x):
		city_layout[floor(grid_size.x / 2)][x] = Layers.ROAD
	
	var roads_determinant = 3
	
	for i in range(roads_determinant):
		
		var random_x = randi() % grid_size.x
		var random_y = randi() % grid_size.y
		
		for y in range(grid_size.y):
			city_layout[y][random_x] = Layers.ROAD
		for x in range(grid_size.y):
			city_layout[random_y][x] = Layers.ROAD

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
			if city_layout[x][y] == Layers.PAVEMENT:
				# Randomly place houses next to pavements
				if randi() % 2 == 0:
					if y > 0 and city_layout[x][y - 1] == Layers.GROUND:
						city_layout[x][y - 1] = Layers.HOUSE
					if y < (grid_size.y - 1) and city_layout[x][y + 1] == Layers.GROUND:
						city_layout[x][y + 1] = Layers.HOUSE
					if x > 0 and city_layout[x - 1][y] == Layers.GROUND:
						city_layout[x - 1][y] = Layers.HOUSE
					if x < (grid_size.x - 1) and city_layout[x + 1][y] == Layers.GROUND:
						city_layout[x + 1][y] = Layers.HOUSE

func fill_grass():
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			if city_layout[x][y] == Layers.GROUND:
				city_layout[x][y] = Layers.GRASS

func fill_grid_with_zeros():
	var grid = [] 
	
	for x in range(grid_size.x):
		var row: Array[int] = []
		for y in range(grid_size.y):
			row.append(0)
		grid.append(row)
	
	return grid

