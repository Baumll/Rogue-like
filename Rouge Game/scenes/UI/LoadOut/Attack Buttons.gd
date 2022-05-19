extends Control

signal attackUP(num) #losgelassen
signal attackDown(num) #Drücken
signal moveDown(move) #Drücken
signal back #Drücken

onready var reckList = [$Attack01/Light2D, $Attack02/Light2D, $Attack03/Light2D, $Attack04/Light2D]
onready var descriptionText = get_node("/root/Main/Control/VBoxContainer/DecriptinText")
var aktive_moves = []


func _on_FightScene_loadCharacter(character):
	if(character == null):
		visible = false
		return
	else:
		visible = true
		aktive_moves = character.moves
		for x in range(reckList.size()):
			if x < character.moves.size():
				reckList[x].set_texture(character.moves[x].image)
			else:
				reckList[x].set_texture(null)

func _on_FightScene_loadAttacks(moves):
	if(moves == null):
		visible = false;
	else:
		visible = true
		aktive_moves = moves
		for x in range(reckList.size()):
			if x < moves.size():
				reckList[x].set_texture(moves[x].image)
				
			else:
				reckList[x].set_texture(null)


func _on_Attack01_button_up():
	emit_signal("attackUP",0)


func _on_Attack02_button_up():
	emit_signal("attackUP",1)


func _on_Attack03_button_up():
	emit_signal("attackUP",2)


func _on_Attack04_button_up():
	emit_signal("attackUP",3)


func _on_ButtonBack_button_up():
	emit_signal("attackUP",-1)




func _on_Attack01_button_down():
	emit_signal("attackDown",0)
	if aktive_moves.size() > 0:
		emit_signal("moveDown",aktive_moves[0])


func _on_Attack02_button_down():
	emit_signal("attackDown",1)
	if aktive_moves.size() > 1:
		emit_signal("moveDown",aktive_moves[1])


func _on_Attack03_button_down():
	emit_signal("attackDown",2)
	if aktive_moves.size() > 2:
		emit_signal("moveDown",aktive_moves[2])


func _on_Attack04_button_down():
	emit_signal("attackDown",3)
	if aktive_moves.size() > 3:
		emit_signal("moveDown",aktive_moves[3])


func _on_Button_button_up():
	emit_signal("back")
