extends Button

signal buttonPressedNum(num)
signal buttonNum(num)

var texture = null
onready var tex = $TextureRect
var number = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	if texture != null:
		set_image(texture)
	tex.rect_size = rect_size

func set_number(num):
	number = num

func set_image(image):
	if(tex == null):
		texture = image
	else:
		tex.texture = image

func change_size(x,y):
	var texture_rect = $TextureRect
	rect_min_size = Vector2(x,y)
	texture_rect.rect_min_size = rect_min_size
	

func change_pos(x,y):
	rect_position = Vector2(x,y)

func _on_char_button_down():
	emit_signal("buttonNum",number)


func _on_char_pressed():
	emit_signal("buttonPressedNum",number)
