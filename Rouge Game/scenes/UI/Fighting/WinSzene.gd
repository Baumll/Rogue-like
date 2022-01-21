extends Control

signal winSzene

onready var lable2 = $MarginContainer/VBoxContainer/Label2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_exp(amount):
	lable2.text = "You Got: " + str(amount) + " Exp"

func _on_Button_pressed():
	emit_signal("winSzene")


func show_item():
	pass
