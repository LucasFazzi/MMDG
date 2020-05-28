extends Node

onready var global_checkpoint_hit = Vector2(-57.068,82.494)
onready var global_player
var global_player_position
var global_total_bosses_defeated = 0
var global_total_doors_opened = 0
var global_total_blocks_destroyed = 0
var boss_destroy = false
var reload = false

func _ready():
	pass

func _process(delta):
	player_position()

func player_position():
	pass
	global_player_position = global_player.global_position
