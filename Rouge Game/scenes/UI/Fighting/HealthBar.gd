extends Control


onready var bar = $H/TextureProgress
onready var label = $H/Label
export(int) var value = 0
export(float) var timeToFull = 10

func _ready():
	bar.value = value*100
	set_bar(1,1)

func _process(delta):
	if value*100 > bar.value:
		bar.value += ceil(bar.max_value*delta)
	elif value*100 < bar.value:
		bar.value -= ceil(bar.max_value*delta)

func set_bar(maximal,amount):
	if(maximal == 0):
			bar.set_value(0)
			value = 0
			label.text = "0"
			label.update()
			return
	bar.set_max(maximal*100)
	bar.set_value(amount*100)
	value = amount
	label.text = str(amount)
	label.update()

func update_bar(amount):
	value = amount
	

func get_value() -> int:
	return value
	

