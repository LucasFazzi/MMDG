extends TextureProgress

var life = 3
signal update

func _process(delta):
	update_text()
	life_zero()

func update_text():
	get_node(".").value = life
func _on_Player_Life_update():
	life -= 1
func life_zero():
	if life <= 0:
		life = 3
