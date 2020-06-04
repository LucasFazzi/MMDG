extends Node2D

var life = 10
var can_hurt = true
var is_visible = false
var can_play_death = false

func _ready():
	add_group()

func _physics_process(delta):
	check_player_win()
	check_life()
	check_life()
	check_visible()

func add_group():
	get_node("Boss_4_KinematicBody").add_to_group("enemies")
	get_node("Boss_4_KinematicBody_2").add_to_group("enemies")

func check_visible():
	if get_node("Boss_4_Visibility").is_on_screen():
		is_visible = true
	if not get_node("Boss_4_Visibility").is_on_screen():
		is_visible = false

	if is_visible == true:
		get_node("Boss_4_KinematicBody/Boss_4_Animation").play("move")
		get_node("Boss_4_KinematicBody_2/Boss_4_Animation").play("move")
	if is_visible == false:
		get_node("Boss_4_KinematicBody/Boss_4_Animation").stop()
		get_node("Boss_4_KinematicBody_2/Boss_4_Animation").stop()

func _on_Boss_4_Hit_area_entered(area):
	if area.is_in_group("player_attack") and can_hurt == true:
		can_hurt = false
		get_node("Boss_Hit_SFX").play()
		get_node("Boss_4_KinematicBody/Boss_4_Sprite").set_modulate(Color(0,0,0))
		var waiting_timer = Timer.new()
		waiting_timer.set_wait_time(0.09)
		waiting_timer.set_one_shot(true)
		call_deferred("add_child", waiting_timer)
		waiting_timer.set_autostart(true)
		yield(waiting_timer, "timeout")
		get_node("Boss_4_KinematicBody/Boss_4_Sprite").set_modulate(Color(1,1,1))
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
		can_play_death = true
		play_death()
		get_node("Boss_4_KinematicBody/Boss_4_Col").disabled = true
		get_node("Boss_4_KinematicBody_2/Boss_4_Col").disabled = true
		get_node("Boss_4_KinematicBody/Boss_4_Hit/Boss_4_Col_Hit").disabled = true
		get_node("Boss_4_KinematicBody_2/Boss_4_Hit/Boss_4_Col_Hit").disabled = true
		get_node("Boss_4_KinematicBody/Boss_4_Sprite").visible = false
		get_node("Boss_4_KinematicBody_2/Boss_4_Sprite").visible = false
		var waiting_timer = Timer.new()
		waiting_timer.set_wait_time(2)
		waiting_timer.set_one_shot(true)
		call_deferred("add_child", waiting_timer)
		waiting_timer.set_autostart(true)
		yield(waiting_timer, "timeout")
		Global_Script.global_total_bosses_defeated += 1
		Global_Script.boss_destroy = true
		get_node(".").call_deferred("queue_free")
	
func play_death():
	if can_play_death == false:
		pass
	else:
		if not get_node("Boss_Death_SFX").is_playing():
			get_node("Boss_Death_SFX").play()
			can_play_death = false

func check_life():
	pass
#	while life <= 7:
#		get_node("Boss_2_Animation").play("move",-1,1.5)
#		return
