extends Area2D

signal hit

func _on_Player_Hit_body_entered(body):
	if body.is_in_group("enemies"):
		emit_signal("hit")
