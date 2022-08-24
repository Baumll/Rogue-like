extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal charButtonDown(character)
export(Resource) var character = null
onready var reck = $reck

# Called when the node enters the scene tree for the first time.
func _ready():
	if character != null:
		set_image(character.icon)


func set_image(tex):
	reck.texture = tex

func set_character(chara):
	character = chara
	set_image(chara.icon)

func _on_Char0_button_down():
	emit_signal("charButtonDown", character)
