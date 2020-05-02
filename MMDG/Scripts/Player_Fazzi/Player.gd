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

#funcs físicas (parede, chão etc.)
	while is_on_wall():
		grab()
		return
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

	while is_on_ceiling():
		Y_VELO += GRAVITY

#funcs de agarrar e pulo
func grab():
	JUMP_COUNT = 3
	Y_VELO = FRICTION_WALL
func jump():
	Y_VELO =- JUMP_FORCE
func jump_cut():
	while Y_VELO < -100:
		Y_VELO = -70
		return
