extends Control


onready var bar = $TextureProgress
export(int) var value

func _ready():
	bar.value = value
	set_bar(66)
		
	
func set_bar(num):
	bar.set_value(num)
	value = num
	
func get_value() -> int:
	return value
	

