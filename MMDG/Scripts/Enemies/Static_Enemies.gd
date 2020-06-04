extends TileMap

func _ready():
	add_group()

func add_group():
	add_to_group("enemies")
