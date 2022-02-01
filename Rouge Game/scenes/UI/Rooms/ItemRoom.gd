extends Control

signal exit
onready var preitem = preload("res://ScribtAble/ClassItem.gd")
onready var ui_under = $Ui_Under


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_button_up():
	for i in range(get_node("/root/Main").inventory.size()):
		if get_node("/root/Main").inventory[i] == null:
			var item = preitem.new()
			item._ready()
			get_node("/root/Main").inventory[i] = item
			emit_signal("exit")
			return
	emit_signal("exit")
