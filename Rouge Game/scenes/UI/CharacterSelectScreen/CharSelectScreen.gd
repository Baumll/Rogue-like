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
	if(charcater == -1):
		#hier noch random einfügen
		emit_signal("Chosen",0)
	else:
		emit_signal("Chosen",charcater)


func _on_Button0_pressed():
	charcater = 0
	desciption_label.text = mage_text
	desciption_label.update()


func _on_Button1_pressed():
	charcater = 1
	desciption_label.text = warrier_text
	desciption_label.update()


func _on_Button2_pressed():
	charcater = 2
	desciption_label.text = ranger_text
	desciption_label.update()


func _on_Button3_pressed():
	charcater = 3
	desciption_label.text = necro_text
	desciption_label.update()
