extends Node2D

signal block_destroyed
signal door_destroyed
signal last_checkpoint
signal reloaded

onready var blocks = [get_node("Blocks/Block_1"), get_node("Blocks/Block_2"), get_node("Blocks/Block_3"), get_node("Blocks/Block_4")]
onready var doors = [get_node("Doors/Door_1"), get_node("Doors/Door_2"), get_node("Doors/Door_3"), get_node("Doors/Door_4")]
onready var boss_pos = [Vector2(9996.85,26.547),Vector2(13287.62,-917.533),Vector2(17046.145,88.228), Vector2(21431.758,-11.725), Vector2(24989.25,105.09)]
var local_total_bosses_defeated
var local_total_doors_opened
var local_total_blocks_destroyed
var start_position

func _ready():
	get_global_info()

func _process(delta):
	is_boss_defeated()
	check_reload()

func get_global_info():
	Global_Script.can_global_position = true
	get_node("Player/CanvasLayer/Death_Screen").visible = false
	start_position = get_node("Player").position
	var waiting_timer = Timer.new()
	waiting_timer.set_wait_time(0.05)
	waiting_timer.set_one_shot(true)
	call_deferred("add_child", waiting_timer)
	waiting_timer.set_autostart(true)
	yield(waiting_timer, "timeout")
	local_total_bosses_defeated = Global_Script.global_total_bosses_defeated
	local_total_doors_opened = Global_Script.global_total_doors_opened
	local_total_blocks_destroyed = Global_Script.global_total_blocks_destroyed
	get_node("Player").position = Global_Script.global_checkpoint_hit
	check_doors_already_opened()
	check_blocks_already_destroyed()

func check_doors_already_opened():
	if local_total_doors_opened > 0 and local_total_doors_opened < 5:
		for i in range(local_total_doors_opened):
			doors[i].queue_free()
	if local_total_doors_opened == 5:
		Global_Script.global_total_blocks_destroyed = 0
		Global_Script.global_total_bosses_defeated = 0
		Global_Script.global_total_doors_opened = 0
		Global_Script.global_checkpoint_hit = Vector2(-57.068,82.494)
		get_tree().change_scene("res://Scenes/Screens/Start_Screen.tscn")

func check_blocks_already_destroyed():
	if local_total_blocks_destroyed > 0 and local_total_blocks_destroyed < 5:
		for i in range(local_total_blocks_destroyed):
			blocks[i].queue_free()

func _on_door_player_entered_door():
	if local_total_doors_opened == 0:
		get_node("Player").position = boss_pos[local_total_doors_opened]
	else:
		for i in range(local_total_doors_opened):
			get_node("Player").position = boss_pos[local_total_doors_opened]

func is_boss_defeated():
	if Global_Script.boss_destroy == true:
		Global_Script.boss_destroy = false
		emit_signal ("block_destroyed")
		emit_signal ("door_destroyed")
		emit_signal ("last_checkpoint")

func _on_Main_World_door_destroyed():
	Global_Script.global_total_doors_opened += 1

func _on_Main_World_block_destroyed():
	Global_Script.global_total_blocks_destroyed += 1

func _on_Main_World_last_checkpoint():
	get_tree().reload_current_scene()

func _on_Player_reload():
	Global_Script.reload = true

func check_reload():
	if Global_Script.reload == true:
		emit_signal("reloaded")
		get_node("Player/Player_Hit/Player_Col_Hit").disabled = true
		get_node("Player/CanvasLayer/Death_Screen").visible = true

func _on_Main_World_reloaded():
	var waiting_timer = Timer.new()
	waiting_timer.set_wait_time(1.5)
	waiting_timer.set_one_shot(true)
	call_deferred("add_child", waiting_timer)
	waiting_timer.set_autostart(true)
	yield(waiting_timer, "timeout")
	get_node("Player/Player_Hit/Player_Col_Hit").disabled = false
	Global_Script.reload = false
	get_tree().reload_current_scene()
