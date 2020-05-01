extends KinematicBody2D

export var MOVE_SPEED = 300
export var JUMP_FORCE = 1100
export var GRAVITY = 50
export var GRAVITY_WALL = 10
export var MAX_FALL_SPEED = 1000
export var Y_VELO = 0
export var JUMP = true
export var DOUBLE_JUMP = false

func _ready():
	add_group()

func _physics_process(delta):
	move()

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

	move_and_slide(Vector2(move_dir * MOVE_SPEED, Y_VELO), Vector2(0, -1)).normalized()
#movimento em eixo y; lembrando que Godot o eixo y é ao contrário
	Y_VELO += GRAVITY

#pulo do Mario; boosta conforme o player soca o dedo
	if Input.is_action_pressed("jump"):
		while is_on_floor() and JUMP == true:
			JUMP = false
			jump()
			return
		if is_on_wall():
#tentativa de fazer um grab wall meio vagabundo
			grab()
#corte do pulo pra desboostar
			while Input.is_action_just_pressed("jump"):
				jump()
				return

	elif Input.is_action_just_released("jump"):
		jump_cut()
	while is_on_ceiling():
		Y_VELO += GRAVITY
		return
	while Y_VELO > MAX_FALL_SPEED:
		Y_VELO = MAX_FALL_SPEED
		return
	while is_on_floor():
		DOUBLE_JUMP = true
		JUMP = true
		return
	if not is_on_floor():
		if Input.is_action_just_pressed("jump"):
			double_jump()

func grab():
	Y_VELO = GRAVITY_WALL
	JUMP = true
	DOUBLE_JUMP = true
func jump():
	Y_VELO =- JUMP_FORCE
	JUMP = true
#pulo duplo
func double_jump():
	if DOUBLE_JUMP == true:
		Y_VELO =- JUMP_FORCE
		DOUBLE_JUMP = false
func jump_cut():
	while Y_VELO < -100:
		Y_VELO = -70
		return
