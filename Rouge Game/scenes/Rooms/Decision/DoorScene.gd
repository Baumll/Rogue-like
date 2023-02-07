extends Control

signal door_enter(num)

onready var leftDoor = $HBoxContainer/MarginContainer/ButtonLeft/TextureRect
onready var rightDoor = $HBoxContainer/MarginContainer2/ButtonRight/TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func setup_doors(left, right):
	leftDoor.texture = left
	rightDoor.texture = right

func _on_ButtonLeft_pressed():
	emit_signal("door_enter",0)


func _on_ButtonRight_pressed():
	emit_signal("door_enter",1)
