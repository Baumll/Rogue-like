extends GridContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(Resource) var CharSelectButton

# Called when the node enters the scene tree for the first time.
func _ready():
	pass



func AddChar():
	var new_button = CharSelectButton
	var button_instance = new_button.instance()
	add_child(button_instance)
	button_instance.setImage()
