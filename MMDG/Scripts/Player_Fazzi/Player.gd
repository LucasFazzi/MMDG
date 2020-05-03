extends KinematicBody2D

var move_speed = 300
var jump_force = 1100
var gravity = 50
var friction_wall = 10
var y_velo = 0
var max_y_velo = 1000
var jump_count = 2
var life = 3
var move_dir


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
	check_death()
	check_max_y_velo()

func add_group():
	#adicionar ao grupo player; se quiser alguma func chamando por grupo, facilita
	get_node(".").add_to_group("player")

func move():
	#movimento em eixo x
	move_dir = 0
	if Input.is_action_pressed("move_right"):
		move_dir += 1
	elif Input.is_action_pressed("move_left"):
		move_dir -= 1
	move_and_slide(Vector2(move_dir * move_speed, y_velo), Vector2(0, -1), false, 4, 0.785398, true).normalized()

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
		if Input.is_action_pressed("move_right"):
			get_node("Player_Hit_Attack/Player_Col_Attack").position.x = 45
		if Input.is_action_pressed("move_left"):
			get_node("Player_Hit_Attack/Player_Col_Attack").position.x = -45
		if Input.is_action_pressed("move_up"):
			get_node("Player_Hit_Attack/Player_Col_Attack").position.y = -45
		if Input.is_action_pressed("move_down"):
			get_node("Player_Hit_Attack/Player_Col_Attack").position.y = 45
		var waiting_timer = Timer.new()
		waiting_timer.set_wait_time(0.1)
		waiting_timer.set_one_shot(true)
		call_deferred("add_child", waiting_timer)
		waiting_timer.set_autostart(true)
		yield(waiting_timer, "timeout")
		get_node("Player_Hit_Attack/Player_Col_Attack").position = Vector2(0,0)
		return

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
			grab_ceiling()
		return
#funcs de agarrar wall, ceiling e pulos
func grab_wall():
	jump_count = 3
	y_velo = friction_wall
func grab_ceiling():
	y_velo -= gravity
	jump_count = 3
	var waiting_timer = Timer.new()
	waiting_timer.set_wait_time(1.5)
	waiting_timer.set_one_shot(true)
	call_deferred("add_child", waiting_timer)
	waiting_timer.set_autostart(true)
	yield(waiting_timer, "timeout")
	fall()

func jump():
	y_velo =- jump_force
func jump_cut():
	while y_velo < -100:
		y_velo = -70
		return

#signal hit do player no ataque
func _on_Player_Hit_Attack_attack_scenario():
	move_dir = -move_dir
	y_velo = -y_velo
func _on_Player_Hit_Attack_attack_enemie():
	move_dir = -move_dir
	y_velo = -y_velo

#signal hit do player em vida
func _on_Player_Hit_hit():
	get_node("Player_Sprite").set_modulate(Color(255,0,0))
	var waiting_timer = Timer.new()
	waiting_timer.set_wait_time(0.05)
	waiting_timer.set_one_shot(true)
	call_deferred("add_child", waiting_timer)
	waiting_timer.set_autostart(true)
	yield(waiting_timer, "timeout")
	get_node("Player_Sprite").set_modulate(Color(255,255,255))
	life -= 1
	get_node("CanvasLayer/Player_Life").emit_signal("update")
	move_hit()
#auto-explicativo
func move_hit():
	if y_velo >= gravity:
		jump()
	if test_move(transform,Vector2(1,0)):
		position.x -= 35
	elif test_move(transform,Vector2(-1,0)):
		position.x += 35
#checar vidas
func check_death():
	if life > 0:
		pass
	else:
		get_tree().call_deferred("reload_current_scene")
