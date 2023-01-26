extends TextureRect

signal level_up

export(StreamTexture) var imageNormal = null
export(StreamTexture) var imagePressed = null

func _ready():
	if(imageNormal != null):
		texture = imageNormal

func _on_Button_button_down():
	emit_signal("level_up")
	if(imagePressed != null):
		texture = imagePressed


func _on_Button_button_up():
	if(imageNormal != null):
		texture = imageNormal
