extends KinematicBody2D

export var move_speed = 300
export var jump_force = 1100
export var gravity = 50
export var friction_wall = 10
export var y_velo = 0
export var jump_count = 2

func _ready():
	add_group()

func _physics_process(delta):
	move()
	fall()
	on_wall()
	on_ceiling()
	on_floor()

func add_group():
	#adicionar ao grupo player; se quiser alguma func chamando por grupo, facilita
	get_node(".").add_to_group("player")

func move():
	#movimento em eixo x
	var move_dir = 0

	if Input.is_action_pressed("move_right"):
		move_dir += 1
	elif Input.is_action_pressed("move_left"):
		move_dir -= 1
	move_and_slide(Vector2(move_dir * move_speed, y_velo), Vector2(0, -1), false, 4, 0.785398, true).normalized()

func fall():
#movimento em eixo y; lembrando que Godot o eixo y é ao contrário
	y_velo += gravity

func on_wall():
#funcs físicas (parede, chão etc.)
	while is_on_wall():
		grab_wall()
		return

func on_floor():
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
		if Input.is_action_pressed("move_up"):
			grab_ceiling()
		else:
			y_velo += gravity
		return

#funcs de agarrar wall e pulo
func grab_wall():
	jump_count = 3
	y_velo = friction_wall
func grab_ceiling():
	y_velo -= gravity
	var waiting_timer = Timer.new()
	waiting_timer.set_wait_time(1.5)
	waiting_timer.set_one_shot(true)
	call_deferred("add_child", waiting_timer)
	waiting_timer.set_autostart(true)
	yield(waiting_timer, "timeout")
	y_velo += gravity
func jump():
	y_velo =- jump_force
func jump_cut():
	while y_velo < -100:
		y_velo = -70
		return
