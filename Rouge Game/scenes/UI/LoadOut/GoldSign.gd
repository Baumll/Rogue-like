extends Control

signal set_gold(num)

func _process(_delta):
	set_gold(GameData.gold)

func set_gold(num):
	emit_signal("set_gold", num)



