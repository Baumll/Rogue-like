extends Button

signal buttonPressedNum(num)
signal buttonNum(num)

var number = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func set_number(num):
	number = num

func set_image(image):
	icon = image

func change_size(x,y):
	rect_min_size = Vector2(x,y)
	rect_size = rect_min_size
	

func change_pos(x,y):
	rect_position = Vector2(x,y)

func _on_char_button_down():
	emit_signal("buttonNum",number)


func _on_char_pressed():
	emit_signal("buttonPressedNum",number)