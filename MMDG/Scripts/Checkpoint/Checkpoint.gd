extends Area2D

var local_checkpoint_hit 
signal global_checkpoint_hit

func _process(delta):
	local_checkpoint_hit()

func local_checkpoint_hit():
	local_checkpoint_hit = get_node(".")

func _on_Checkpoint_1_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("global_checkpoint_hit")

func _on_Checkpoint_1_global_checkpoint_hit():
	Global_Script.global_checkpoint_hit = local_checkpoint_hit.position
