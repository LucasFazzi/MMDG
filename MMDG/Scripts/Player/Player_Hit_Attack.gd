extends Area2D

signal attack_enemie
signal attack_scenario

func _ready():
	add_group()

func add_group():
	get_node(".").add_to_group("player_attack")

func _on_Player_Hit_Attack_body_entered(body):
	if body.is_in_group("wall"):
		emit_signal("attack_scenario")
	if body.is_in_group("enemies"):
		emit_signal("attack_enemie")
