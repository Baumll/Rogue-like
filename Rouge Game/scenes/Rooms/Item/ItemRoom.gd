extends Control

signal exit
onready var ui_under = $Ui_Under


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_button_up():
<<<<<<< HEAD
	GlobalFunktions.add_item(GlobalFunktions.create_item())
=======
	for i in range(get_node("/root/Main").inventory.size()):
		if get_node("/root/Main").inventory[i] == null:
			get_node("/root/Main").inventory[i] = GlobalFunktions.create_item()
			emit_signal("exit")
			return
>>>>>>> b26ad2a4a3b997982141b5ee3200de834facf93d
	emit_signal("exit")
