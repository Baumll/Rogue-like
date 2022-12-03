extends Control


signal choise_made(num)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	emit_signal("choise_made",0)


func _on_Button2_pressed():
		emit_signal("choise_made",1)
