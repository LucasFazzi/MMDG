extends KinematicBody2D

var life = 2
var play_style = [1,2]
var can_hurt = true

func _ready():
	add_group()
	move()


func add_group():
	get_node(".").add_to_group("enemies")

func _process(delta):
	check_life()

func move():
	get_node("Enemy_5_Animation_Move").play("move")


func _on_Enemy_5_Hit_area_entered(area):
	if area.is_in_group("player_attack") and can_hurt == true:
		can_hurt = false
		get_node("Enemy_5_Sprite").set_modulate(Color(0,0,0))
		var waiting_timer = Timer.new()
		waiting_timer.set_wait_time(0.09)
		waiting_timer.set_one_shot(true)
		call_deferred("add_child", waiting_timer)
		waiting_timer.set_autostart(true)
		yield(waiting_timer, "timeout")
		get_node("Enemy_5_Sprite").set_modulate(Color(1,1,1))
		life -= 1
		can_hurt = true

func check_life():
	if life > 0:
		pass
	else:
		get_node(".").call_deferred("queue_free")
