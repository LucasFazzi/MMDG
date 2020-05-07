extends Area2D

signal hit
var can_hit = true

func _process(delta):
	is_hurting()

func is_hurting():
	while get_overlapping_bodies() and can_hit == true:
		emit_signal("hit")
		can_hit = false
		var waiting_timer = Timer.new()
		waiting_timer.set_wait_time(0.5)
		waiting_timer.set_one_shot(true)
		call_deferred("add_child", waiting_timer)
		waiting_timer.set_autostart(true)
		yield(waiting_timer, "timeout")
		can_hit = true
		return
