extends Control

signal attack(num)

onready var reckList = [$HBoxContainer/Attack01/TextureRect, $HBoxContainer/Attack02/TextureRect, $HBoxContainer2/Attack03/TextureRect, $HBoxContainer2/Attack04/TextureRect]
onready var descriptionText = get_node("/root/Main/Control/VBoxContainer/DecriptinText")
var aktive_moves = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Attack01_pressed():
	if aktive_moves != null && aktive_moves.size() > 0:
		descriptionText.set_text(aktive_moves[0].description)
	emit_signal("attack",0)


func _on_Attack02_pressed():
	if aktive_moves != null && aktive_moves.size() > 1:
		descriptionText.set_text(aktive_moves[1].description)
	emit_signal("attack",1)


func _on_Attack03_pressed():
	if aktive_moves != null && aktive_moves.size() > 2:
		descriptionText.set_text(aktive_moves[2].description)
	emit_signal("attack",2)


func _on_Attack04_pressed():
	print("Attack4")
	if aktive_moves != null && aktive_moves.size() > 3:
		descriptionText.set_text(aktive_moves[3].description)
	emit_signal("attack",3)


func _on_FightScene_loadAttacks(moves):
	aktive_moves = moves
	for x in range(reckList.size()):
		if x < moves.size():
			reckList[x].set_texture(moves[x].image)
			
		else:
			reckList[x].set_texture(null)


func _on_ButtonBack_pressed():
	emit_signal("attack",-1)
	
