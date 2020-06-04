extends KinematicBody2D

var play_style = [1,2]
var is_visible = false

func _ready():
	add_group()
	shuffle_anim()

func _physics_process(delta):
	check_if_visible()

func add_group():
	get_node(".").add_to_group("enemies")

func shuffle_anim():
	randomize()
	play_style.shuffle()

func check_if_visible():
	if get_node("Enemy_3_Visibility").is_on_screen():
		is_visible = true
	else:
		is_visible = false

	if is_visible == true:
		move()

func move():
	if play_style[0] == 1:
		while not get_node("Enemy_3_Animation_Move").is_playing():
			get_node("Enemy_3_Animation_Move").play("move")
			return
	elif play_style[0] == 2:
		while not get_node("Enemy_3_Animation_Move").is_playing():
			get_node("Enemy_3_Animation_Move").play_backwards("move")
			return

func _on_Enemy_3_Hit_area_entered(area):
	if area.is_in_group("player_attack"):
		get_node("Enemy_3_Hit/Enemy_Hit_SFX").play()
		get_node("Enemy_3_Sprite").set_modulate(Color(0,0,0))
		var waiting_timer = Timer.new()
		waiting_timer.set_wait_time(0.09)
		waiting_timer.set_one_shot(true)
		call_deferred("add_child", waiting_timer)
		waiting_timer.set_autostart(true)
		yield(waiting_timer, "timeout")
		get_node(".").call_deferred("queue_free")
