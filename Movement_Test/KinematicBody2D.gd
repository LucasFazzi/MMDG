extends KinematicBody2D


export var MOVE_SPEED = 300
export var JUMP_FORCE = 1100
export var GRAVITY = 50
export var MAX_FALL_SPEED = 1000
export var y_velo = 0


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

	move_and_slide(Vector2(move_dir * MOVE_SPEED, y_velo), Vector2(0, -1)).normalized()
#movimento em eixo y; lembrando que Godot o eixo y é ao contrário
	y_velo += GRAVITY

#pulo do Mario; boosta conforme o player soca o dedo
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		jump()
	elif Input.is_action_just_released("jump"):
		jump_cut()

	while is_on_ceiling():
		y_velo += GRAVITY
		return
	while y_velo > MAX_FALL_SPEED:
		y_velo = MAX_FALL_SPEED
		return

func jump():
	y_velo = - JUMP_FORCE

func jump_cut():
	if y_velo < -100:
		y_velo = -70
