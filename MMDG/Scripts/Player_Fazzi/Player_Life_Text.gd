extends TextureProgress

var life = 3
signal update

func _process(delta):
	update_text()

func update_text():
	get_node(".").value = life
func _on_Player_Life_update():
	life -= 1
