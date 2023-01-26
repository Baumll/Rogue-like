extends Panel
signal bought(move,number)

onready var money = $Label
onready var icon = $TextureRect
onready var label = $Label2
onready var buy_button = $Button
var save_thing = null
var number = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_move(move, cost):
	if cost > GameData.gold:
		disable()
	save_thing = move
	money.text = str(cost) + "g"
	icon.texture = move.icon
	label.text = move.name

func set_hero(hero, cost):
	if cost > GameData.gold:
		disable()
	save_thing = hero
	money.text = str(cost) + "g"
	icon.texture = load(hero['Icon'])
	label.text = hero['Name']

func disable():
	modulate = Color(0.145098, 0.145098, 0.145098)
	buy_button.flat = true


func _on_Button_button_up():
	emit_signal("bought", save_thing)
