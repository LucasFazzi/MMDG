extends KinematicBody2D

var play_style = [1,2]

func _ready():
	add_group()
	shuffle_anim()

func add_group():
	get_node(".").add_to_group("enemies")

func shuffle_anim():
	play_style.shuffle()
	move()

func move():
	if play_style[0] == 1:
		get_node("Enemy_4_Animation_Move").play("move")
	else:
		get_node("Enemy_4_Animation_Move").play_backwards("move")

func _on_Enemy_4_Hit_area_entered(area):
	if area.is_in_group("player_attack"):
		get_node("Enemy_4_Sprite").set_modulate(Color(0,0,0))
		var waiting_timer = Timer.new()
		waiting_timer.set_wait_time(0.09)
		waiting_timer.set_one_shot(true)
		call_deferred("add_child", waiting_timer)
		waiting_timer.set_autostart(true)
		yield(waiting_timer, "timeout")
		get_node(".").call_deferred("queue_free")

func _on_Enemy_4_Animation_Move_animation_finished():
	shuffle_anim()
