extends Control

signal Chosen(num)

onready var desciption_label = $VBoxContainer/CenterContainer4/Description
onready var character_buttons = [$VBoxContainer/CenterContainer2/GridContainer/Char0,$VBoxContainer/CenterContainer2/GridContainer/Char1,$VBoxContainer/CenterContainer2/GridContainer/Char2,$VBoxContainer/CenterContainer2/GridContainer/Char3]
var charcater = null
#0 = Magier 1= Krieger 2=Waldläufer 3= Nektomant?
export(String) var start_text = "Wähle deinen Helden!"


# Called when the node enters the scene tree for the first time.
func _ready():
	desciption_label.text = start_text
	desciption_label.update()
	#Read Characters fist 4 Characters:
	var character_list = GlobalFunktions.get_hero_list()
	for i in range(min(GlobalFunktions.team_size,len(character_list))):
		character_buttons[i].set_character(GlobalFunktions.get_hero(character_list[i]["Name"]))


#Verchickt den neuen Character
func _on_Start_pressed():
	if charcater != null:
		emit_signal("Chosen",charcater)


func _on_Char_charButtonDown(character):
	charcater = character
	desciption_label.text = character.description
	desciption_label.update()
