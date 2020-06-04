extends RichTextLabel

var local_points = 0

func _process(delta):
	update_time()
	update_text()

func update_time():
	local_points = Global_Script.global_points
func update_text():
	get_node(".").text = str(local_points)
