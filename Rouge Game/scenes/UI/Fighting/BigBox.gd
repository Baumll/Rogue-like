extends MarginContainer


signal down(num)
signal up(num)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_button_down():
	emit_signal("down",0)


func _on_Button_button_up():
	emit_signal("up",0)


func _on_Button2_button_down():
	emit_signal("down",1)


func _on_Button2_button_up():
	emit_signal("up",1)


func _on_Button3_button_down():
	emit_signal("down",2)


func _on_Button3_button_up():
	emit_signal("up",2)


func _on_Button4_button_down():
	emit_signal("down",3)


func _on_Button4_button_up():
	emit_signal("up",3)


func _on_Button5_button_down():
	emit_signal("down",4)


func _on_Button5_button_up():
	emit_signal("up",4)


func _on_Button6_button_down():
	emit_signal("down",5)


func _on_Button6_button_up():
	emit_signal("up",5)
