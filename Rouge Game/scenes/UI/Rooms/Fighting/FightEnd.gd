extends Control

signal exit

var time = 0.5
var ep = 0
var character = []
var items = []

onready var barlist = [$C/H,$C/H2,$C/H3,$C/H4]

func _ready():
	for i in barlist:
		i.visible = false
	visible = false

func let_it_begin(chars, items, ep):
	#jeder Char bekommt gleich viel EP
	#Die Anzahl die angeben ist. 
	visible = true
	if chars != null:
		for i in range(chars.size()):
			barlist[i].visible = true
			barlist[i].get_child(1).set_bar(chars[i].baseExpToLevel*chars[i].level,chars[i].experiencePoints)
			barlist[i].get_child(1).update_bar(chars[i].experiencePoints+ep)
			ChrFunc.give_exp(chars[i],ep)
			ChrFunc.reset_health(chars[i])


func _on_Button_button_down():
	emit_signal("exit")
