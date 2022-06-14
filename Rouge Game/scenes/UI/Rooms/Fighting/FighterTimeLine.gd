extends Control

onready var rect_list = [$CenterContainer/HBoxContainer/TextureRect
,$CenterContainer/HBoxContainer/TextureRect2
,$CenterContainer/HBoxContainer/TextureRect3
,$CenterContainer/HBoxContainer/TextureRect4
,$CenterContainer/HBoxContainer/TextureRect5
,$CenterContainer/HBoxContainer/TextureRect6
,$CenterContainer/HBoxContainer/TextureRect7
,$CenterContainer/HBoxContainer/TextureRect8]

onready var turn_signal = $CenterContainer/HBoxContainer/TurnSignal
onready var prev_signal = $CenterContainer/HBoxContainer/PrevSignal
onready var HBox = $CenterContainer/HBoxContainer
# Called when the node enters the scene tree for the first time.
func _ready():
	prev_signal.visible = false


func set_order(list, move = null, icon = null):
	#Wenn ein Move mitgegeben wird, dann Wird geschaut an welcher Position der Held wäre
	var signal_set = false; #Schauen ob Turn ganz ans Ende gesetzt werden muss
	var prev_set = 0
	prev_signal.visible = false
	for i in rect_list:
		i.rect_size = Vector2(60,60)
		i.texture = null
	for i in range(list.size()):
		if i < rect_list.size():
			#if(list[i].momentum <= 0 and !signal_set):
				#HBox.move_child(turn_signal,rect_list[i].get_index())
				#signal_set = true
			if(move != null):
				#print(str(list[0].momentum ) + " - "+ str(move.cost) +" > "+ str(list[i].momentum))
				if (list[0].momentum - move.cost) > list[i].momentum and prev_set == 0:
					prev_set = 1
					HBox.move_child(prev_signal,i)
					prev_signal.visible = true
					if icon != null:
						prev_signal.texture = icon
			rect_list[i].texture = list[i].icon
	if(!signal_set):
		HBox.move_child(turn_signal,list.size())
	if(move != null):
		#print("Cost: " + str(move.cost))
		if( prev_set == 0):
			prev_signal.visible = true
			if icon != null:
				prev_signal.texture = icon
			if(list[0].momentum - move.cost > 0):
				HBox.move_child(prev_signal,list.size())
			else:
				HBox.move_child(prev_signal,list.size()+1)
	#Vergrößert den ersten Platz
	HBox.get_child(0).rect_size = Vector2(80,80)
