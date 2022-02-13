extends Node



func create_floaty_text(amount, position, color = Color('33040b') ):
	if(amount != null):
		var floaty_text_scene = load("res://scenes/UI/Fighting/Floating_Text.tscn")
		var floaty_text = floaty_text_scene.instance()
		
		floaty_text.position = position #Vector2(480/2, 270/2)
		floaty_text.velocity = Vector2(rand_range(-100, 100), -200)
		floaty_text.modulate = color#Color(rand_range(0.7, 1), rand_range(0.7, 1), rand_range(0.7, 1), 1.0)
		### White
		#floaty_text.modulate = Color(1.0, 1.0, 1.0, 1.0)
		#var amount = randi()%10 - 5
		floaty_text.text = amount
		
		if amount > 0:
			floaty_text.text = floaty_text.text
		add_child(floaty_text)
