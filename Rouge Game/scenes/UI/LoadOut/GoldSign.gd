extends Control

signal set_gold(num)

func _process(delta):
	set_gold(get_node("/root/Main").gold )

func set_gold(num):
	emit_signal("set_gold", num)


func _on_GoldSign_set_gold(num):
	pass # Replace with function body.