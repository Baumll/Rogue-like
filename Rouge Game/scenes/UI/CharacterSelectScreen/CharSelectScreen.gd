extends Control

signal Chosen(num)

onready var desciption_label = $VBoxContainer/CenterContainer4/Description
var charcater = -1
#0 = Magier 1= Krieger 2=Waldläufer 3= Nektomant?
export(String) var start_text = ""
export(String) var mage_text = "Ein mystischer magier"
export(String) var warrier_text = "Ein starker Krieger"
export(String) var ranger_text = "Ein schneller Waldläufer"
export(String) var necro_text = "Ein Magier der gerne \n freunde hätte"

# Called when the node enters the scene tree for the first time.
func _ready():
	desciption_label.text = start_text
	desciption_label.update()


func _on_Start_pressed():
	emit_signal("Chosen",ChrFunc.new_character(charcater))


func _on_Char_charButtonDown(character):
	charcater = character
	desciption_label.text = character.description
	desciption_label.update()
