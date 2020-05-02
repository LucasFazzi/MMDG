extends KinematicBody2D

export var MOVE_SPEED = 300
export var JUMP_FORCE = 1100
export var GRAVITY = 50
export var FRICTION_WALL = 10
export var Y_VELO = 0
export var JUMP_COUNT = 2

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
	var MOVE_DIR = 0

	if Input.is_action_pressed("move_right"):
		MOVE_DIR += 1
	elif Input.is_action_pressed("move_left"):
		MOVE_DIR -= 1
	move_and_slide(Vector2(MOVE_DIR * MOVE_SPEED, Y_VELO), Vector2(0, -1), false, 4, 0.785398, true).normalized()

func fall():
#movimento em eixo y; lembrando que Godot o eixo y é ao contrário
	Y_VELO += GRAVITY

func on_wall():
#funcs físicas (parede, chão etc.)
	while is_on_wall():
		grab_wall()
		return

func on_floor():
	while is_on_floor():
		if JUMP_COUNT < 2:
			JUMP_COUNT = 2
		if Input.is_action_pressed("jump"):
			jump()
		return
	if Input.is_action_just_released("jump"):
		jump_cut()

	while not is_on_floor():
		if Input.is_action_just_pressed("jump") and JUMP_COUNT > 1:
			JUMP_COUNT -= 1
			jump()
		return

func on_ceiling():
	while is_on_ceiling():
		if Input.is_action_pressed("move_up"):
			grab_ceiling()
		else:
			Y_VELO += GRAVITY
		return

#funcs de agarrar e pulo
func grab_wall():
	JUMP_COUNT = 3
	Y_VELO = FRICTION_WALL
func grab_ceiling():
	Y_VELO -= GRAVITY
	var waiting_timer = Timer.new()
	waiting_timer.set_wait_time(1.5)
	waiting_timer.set_one_shot(true)
	call_deferred("add_child", waiting_timer)
	waiting_timer.set_autostart(true)
	yield(waiting_timer, "timeout")
	Y_VELO += GRAVITY
func jump():
	Y_VELO =- JUMP_FORCE
func jump_cut():
	while Y_VELO < -100:
		Y_VELO = -70
		return
