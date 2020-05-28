extends KinematicBody2D

var life = 1
var can_hurt = true
var is_visible = false

func _ready():
	add_group()

func _physics_process(delta):
	check_player_win()
	check_life()
	check_visible()

func add_group():
	get_node(".").add_to_group("enemies")

func check_visible():
	if get_node("Boss_2_Visibility").is_on_screen():
		is_visible = true
	if not get_node("Boss_2_Visibility").is_on_screen():
		is_visible = false

	if is_visible == true:
		get_node("Boss_2_Animation").play("move")
	if is_visible == false:
			get_node("Boss_2_Animation").stop()

func _on_Boss_2_Hit_area_entered(area):
	if area.is_in_group("player_attack") and can_hurt == true:
		can_hurt = false
		get_node("Boss_2_Sprite").set_modulate(Color(0,0,0))
		var waiting_timer = Timer.new()
		waiting_timer.set_wait_time(0.09)
		waiting_timer.set_one_shot(true)
		call_deferred("add_child", waiting_timer)
		waiting_timer.set_autostart(true)
		yield(waiting_timer, "timeout")
		get_node("Boss_2_Sprite").set_modulate(Color(1,1,1))
		var waiting_timer_2 = Timer.new()
		waiting_timer_2.set_wait_time(0.5)
		waiting_timer_2.set_one_shot(true)
		call_deferred("add_child", waiting_timer_2)
		waiting_timer_2.set_autostart(true)
		yield(waiting_timer_2, "timeout")
		life -= 1
		can_hurt = true

func check_player_win():
	if life <= 0:
		Global_Script.global_total_bosses_defeated += 1
		Global_Script.boss_destroy = true
		get_node(".").call_deferred("queue_free")

func check_life():
	while life <= 7:
		get_node("Boss_2_Animation").play("move",-1,1.5)
		return
