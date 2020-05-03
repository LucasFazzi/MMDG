extends Area2D

signal attack_enemie
signal attack_scenario

func _on_Player_Hit_Attack_body_entered(body):
	if body.is_in_group("wall"):
		emit_signal("attack_scenario")
	if body.is_in_group("enemies"):
		emit_signal("attack_enemie")
