extends Control


onready var bar = $TextureProgress
onready var label = $Label
export(int) var value

func _ready():
	bar.value = value
	set_bar(1,1)
		
	
func set_bar(maximal,amount):
	if(maximal == 0):
			bar.set_value(0)
			value = 0
			label.text = "0/0"
			label.update()
			return
	var num = amount/maximal*100
	bar.set_value(num)
	value = num
	label.text = str(amount)+ "/" + str(maximal)
	label.update()
func get_value() -> int:
	return value
	

