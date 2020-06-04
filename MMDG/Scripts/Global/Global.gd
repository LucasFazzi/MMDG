extends Node

onready var global_checkpoint_hit = Vector2(-57.068,82.494)
onready var global_player
var global_player_position
var global_total_bosses_defeated = 0
var global_total_doors_opened = 0
var global_total_blocks_destroyed = 0
var boss_destroy = false
var reload = false
var can_global_position = false
var global_delta_cicle = 0
var global_points = 0

func _process(delta):
	player_position()
	update_time()

func player_position():
	if can_global_position == true:
		if not not global_player == null:
			global_player_position = global_player.global_position
	else:
		pass

func update_time():
	global_delta_cicle += 1
	if global_delta_cicle >= 600:
		global_points += 1
		global_delta_cicle = 0
