extends KinematicBody2D

signal reload

var move_speed = lerp(300,295,2)
var jump_force = lerp(1100,1090,2)
var move_dir_vel = lerp(1,0,0.25)
var move_dir
var gravity = lerp(50,47,1)
var friction_wall = lerp(10,7,1.5)
var y_velo = 0
var y_velo_jump_cut = lerp(-70,-65,1)
var max_y_velo = lerp(1000,980,2)
var jump_count = 2
var life = 3
var can_hurt = true
var get_checkpoint

func _ready():
	add_group()

func _physics_process(delta):
	move()
	fall()
	on_wall()
	on_ceiling()
	on_floor()
	attack()

func _process(delta):
	check_max_y_velo()
	restart()
	get_checkpoint()

func add_group():
	#adicionar ao grupo player; se quiser alguma func chamando por grupo, facilita
	get_node(".").add_to_group("player")
	Global_Script.global_player = self

func move():
	#movimento em eixo x
	move_dir = 0
	if Input.is_action_pressed("move_right"):
		move_dir += move_dir_vel
	elif Input.is_action_pressed("move_left"):
		move_dir -= move_dir_vel
	move_and_slide(Vector2(move_dir * move_speed, y_velo), Vector2(0, -1), false, 4, 0.785398, true).normalized()

func restart():
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()

func fall():
#movimento em eixo y; lembrando que Godot o eixo y é ao contrário
	y_velo += gravity

func check_max_y_velo():
#y continua calculando no delta; para evitar que aumente a velocidade acima da gravidade
	if y_velo > max_y_velo:
		y_velo = max_y_velo
#move do colisor de hitbox para ataque
func attack():
	while Input.is_action_just_pressed("attack"):
		get_node("Player_Attack_SFX").play()
		if Input.is_action_pressed("move_right"):
			attack_pos(55,0,270)
		elif Input.is_action_pressed("move_left"):
			attack_pos(-55,0,270)
		elif Input.is_action_pressed("move_up"):
			attack_pos(0,-55,180)
		elif Input.is_action_pressed("move_down"):
			attack_pos(0,55,180)
		else:
			parry()
		var waiting_timer = Timer.new()
		waiting_timer.set_wait_time(0.2)
		waiting_timer.set_one_shot(true)
		call_deferred("add_child", waiting_timer)
		waiting_timer.set_autostart(true)
		yield(waiting_timer, "timeout")
		attack_pos(0,0,0)
		return
func attack_pos(pos_x,pos_y,rot):
	get_node("Player_Hit_Attack/Player_Col_Attack").position.x = pos_x
	get_node("Player_Hit_Attack/Player_Col_Attack").position.y = pos_y
	get_node("Player_Hit_Attack/Player_Col_Attack").rotation_degrees = rot

func parry():
	parry_turn(Vector2(1.5,1.5),Vector2(2.8,2.8),true)
	var waiting_timer = Timer.new()
	waiting_timer.set_wait_time(0.3)
	waiting_timer.set_one_shot(true)
	call_deferred("add_child", waiting_timer)
	waiting_timer.set_autostart(true)
	yield(waiting_timer, "timeout")
	parry_turn(Vector2(1,1),Vector2(2.3,2.3),false)
func parry_turn(body_scale,sprite_scale,hit_disabled):
	get_node("Player_Col_Body").scale = body_scale
	get_node("Player_Sprite").scale = sprite_scale
	get_node("Player_Hit/Player_Col_Hit").disabled = hit_disabled

func on_wall():
#funcs físicas (parede, chão etc.)
	while is_on_wall():
		grab_wall()
		return

func on_floor():
#contadores em solo e input do pulo
	while is_on_floor():
		if jump_count < 2:
			jump_count = 2
		if Input.is_action_pressed("jump"):
			jump()
		return
	if Input.is_action_just_released("jump"):
		jump_cut()

	while not is_on_floor():
		if Input.is_action_just_pressed("jump") and jump_count > 1:
			jump_count -= 1
			jump()
		return
#agarrada no teto
func on_ceiling():
	while is_on_ceiling():
		if Input.is_action_pressed("move_up") or Input.is_action_pressed("grab_up"):
			var waiting_timer = Timer.new()
			waiting_timer.set_wait_time(0.5)
			waiting_timer.set_one_shot(true)
			call_deferred("add_child", waiting_timer)
			waiting_timer.set_autostart(true)
			yield(waiting_timer, "timeout")
			fall()
		return
#funcs de agarrar wall, ceiling e pulos
func grab_wall():
	jump_count = 3
	y_velo = friction_wall

func jump():
	y_velo =- jump_force
	get_node("Player_Jump_SFX").play()
func jump_hit():
	y_velo =- jump_force / 2
func jump_cut():
	while y_velo < -100:
		y_velo = y_velo_jump_cut
		return

#signal hit do player no ataque
func _on_Player_Hit_Attack_attack_scenario():
	check_hit_attack()
func _on_Player_Hit_Attack_attack_enemie():
	check_hit_attack()

func check_hit_attack():
	while is_on_floor():
		if Input.is_action_pressed("move_right"):
			check_hit_pos(-10,3)
		elif Input.is_action_pressed("move_left"):
			check_hit_pos(10,3)
		return
	while not is_on_floor():
		if Input.is_action_pressed("move_right"):
			check_hit_pos(-10,3)
		elif Input.is_action_pressed("move_left"):
			check_hit_pos(10,3)
		else:
			y_velo = -y_velo
			jump_count = 3
		return
func check_hit_pos(pos_x,jump_count):
	global_position.x += pos_x
	jump_count = 3
#signal hit do player em vida
func _on_Player_Hit_hit():
	move_hit()
	if can_hurt == true:
		can_hurt = false
		get_node("Player_Hit_SFX").play()
		get_node("Player_Sprite").set_modulate(Color(255,0,0))
		get_tree().paused = true
		yield(get_tree().create_timer(0.400), 'timeout')
		get_tree().paused = false
		var waiting_timer = Timer.new()
		waiting_timer.set_wait_time(0.05)
		waiting_timer.set_one_shot(true)
		call_deferred("add_child", waiting_timer)
		waiting_timer.set_autostart(true)
		yield(waiting_timer, "timeout")
		get_node("Player_Sprite").set_modulate(Color(255,255,255))
		life -= 1
		check_death()
		get_node("CanvasLayer/Player_Life").emit_signal("update")
		can_hurt = true
#auto-explicativo
func move_hit():
	if is_on_ceiling():
		fall()
	else:
		jump_hit()

func get_checkpoint():
	get_checkpoint = Global_Script.global_checkpoint_hit
#checar vidas
func check_death():
	if life > 0:
		pass
	else:
		if get_checkpoint == null:
			get_node("Player_GameOver_SFX").play()
			emit_signal("reload")
		else:
			get_node("Player_GameOver_SFX").play()
			emit_signal("reload")
