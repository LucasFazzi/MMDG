extends KinematicBody2D

var player_pos
var control_speed = 0.9
var move_dir = 200
var life = 3
var can_hurt = true
var is_visible = false
var is_attacking = false
var is_moving = true
var initial_pos
var velocity = Vector2(0,0)

func _ready():
	add_group()
	initial_pos()

func add_group():
	get_node(".").add_to_group("enemies")

func _physics_process(delta):
	check_life()
	check_move()
	check_visible()

func initial_pos():
	initial_pos = get_node(".").position

func check_visible():
	if get_node("Enemy_7_Visibility").is_on_screen():
		is_visible = true

func check_move():
	if is_visible == true and is_attacking == false:
		pass
	elif is_visible == true and is_attacking == true:
		move_attack()

func move_attack():
	if get_node("Player_Direction").get_cast_to().x < 0:
		move_and_slide(Vector2(-move_dir,0) * control_speed, Vector2(0, 0), false, 4, 0.785398, true).normalized()
		var waiting_timer = Timer.new()
		waiting_timer.set_wait_time(1)
		waiting_timer.set_one_shot(true)
		call_deferred("add_child", waiting_timer)
		waiting_timer.set_autostart(true)
		yield(waiting_timer, "timeout")
		stop()
	elif get_node("Player_Direction").get_cast_to().x > 0:
		move_and_slide(Vector2(move_dir,0) * control_speed, Vector2(0, 0), false, 4, 0.785398, true).normalized()
		var waiting_timer = Timer.new()
		waiting_timer.set_wait_time(1)
		waiting_timer.set_one_shot(true)
		call_deferred("add_child", waiting_timer)
		waiting_timer.set_autostart(true)
		yield(waiting_timer, "timeout")
		stop()

func stop():
	is_attacking = false
	while get_node(".").position == initial_pos:
		pass
		return
	while get_node(".").position != initial_pos and get_node("Player_Direction").get_cast_to().x < 0:
		move_and_slide(Vector2(move_dir,0), Vector2(0, 0), false, 4, 0.785398, true).normalized()
		return
	while get_node(".").position != initial_pos and get_node("Player_Direction").get_cast_to().x > 0:
		move_and_slide(Vector2(-move_dir,0), Vector2(0, 0), false, 4, 0.785398, true).normalized()
		return

func _on_Enemy_7_Hit_area_entered(area):
	if area.is_in_group("player_attack") and can_hurt == true:
		can_hurt = false
		get_node("Enemy_7_Hit/Enemy_Hit_SFX").play()
		get_node("Enemy_7_Sprite").set_modulate(Color(0,0,0))
		var waiting_timer = Timer.new()
		waiting_timer.set_wait_time(0.09)
		waiting_timer.set_one_shot(true)
		call_deferred("add_child", waiting_timer)
		waiting_timer.set_autostart(true)
		yield(waiting_timer, "timeout")
		get_node("Enemy_7_Sprite").set_modulate(Color(1,1,1))
		life -= 1
		can_hurt = true

func _on_Enemy_7_FOV_body_entered(body):
	if body.is_in_group("player"):
		is_attacking = true
		get_node("Player_Direction").set_cast_to(body.global_position - get_node(".").global_position)
		player_pos = get_node("Player_Direction").get_cast_to()
func _on_Enemy_7_FOV_body_exited(body):
	stop()

func _on_Enemy_7_Wall_FOV_body_entered(body):
	if body.is_in_group("wall") or body.is_in_group("enemies"):
		stop()

func check_life():
	if life > 0:
		pass
	else:
		get_node(".").call_deferred("queue_free")
