extends KinematicBody2D

var life = 20
var can_hurt = true

func _ready():
	add_group()
	move()

func _physics_process(delta):
	check_player_win()
	check_life()

func add_group():
	get_node(".").add_to_group("enemies")

func move():
	var waiting_timer = Timer.new()
	waiting_timer.set_wait_time(2)
	waiting_timer.set_one_shot(true)
	call_deferred("add_child", waiting_timer)
	waiting_timer.set_autostart(true)
	yield(waiting_timer, "timeout")
	get_node("Boss_1_Animation").play("move")

func _on_Boss_1_Hit_area_entered(area):
	if area.is_in_group("player_attack") and can_hurt == true:
		can_hurt = false
		get_node("Boss_1_Sprite").set_modulate(Color(0,0,0))
		var waiting_timer = Timer.new()
		waiting_timer.set_wait_time(0.09)
		waiting_timer.set_one_shot(true)
		call_deferred("add_child", waiting_timer)
		waiting_timer.set_autostart(true)
		yield(waiting_timer, "timeout")
		get_node("Boss_1_Sprite").set_modulate(Color(1,1,1))
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
		get_node(".").call_deferred("queue_free")

func check_life():
	while life <= 10:
		get_node("Boss_1_Animation").play("move",-1,1.5)
		return
