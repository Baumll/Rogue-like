extends Control

onready var fighter_reckt_list = [
	$VBoxContainer/HBoxContainer/TextureRect,
	$VBoxContainer/HBoxContainer/TextureRect2,
	$VBoxContainer/HBoxContainer/TextureRect3,
	$VBoxContainer/HBoxContainer/TextureRect4,
	$VBoxContainer/HBoxContainer2/TextureRect,
	$VBoxContainer/HBoxContainer2/TextureRect2,
	$VBoxContainer/HBoxContainer2/TextureRect3,
	$VBoxContainer/HBoxContainer2/TextureRect4,
]

var targetFindScript = preload("res://ScribtAble/TargetFindScript.gd")
var activeMove = null
var activePos = -1
var teamSize = 4
var posColor = Color("5dade2")
var friendlyColor = Color("2ecc71")
var enemyColor = Color("ec7063")
var preTime = -1

func _ready():
	targetFindScript = targetFindScript.new()

func _process(delta):
	if activePos != -1:
		if preTime == -1:
			preTime = OS.get_ticks_msec()
		if (OS.get_ticks_msec()-preTime)/1000 > 1:
			preTime = OS.get_ticks_msec()
			for i in fighter_reckt_list:
				i.set_modulate(Color("#ffffff"))
			visible = true
			var targetList = targetFindScript.select_targets(activePos, activeMove)
			for i in targetList:
				if i < teamSize:
					fighter_reckt_list[i].set_modulate(enemyColor)
				else:
					fighter_reckt_list[i].set_modulate(friendlyColor)
			fighter_reckt_list[activePos].set_modulate(posColor)
			
			#yield(get_tree().create_timer(2), "timeout")
			activePos = fmod(activePos+1,teamSize)+4

func _on_set_move(move):
	activeMove = move
	activePos = teamSize
	preTime = OS.get_ticks_msec()
	for i in fighter_reckt_list:
		i.set_modulate(Color("#ffffff"))
	visible = true
	var targetList = targetFindScript.select_targets(activePos, activeMove)
	for i in targetList:
		if i < teamSize:
			fighter_reckt_list[i].set_modulate(enemyColor)
		else:
			fighter_reckt_list[i].set_modulate(friendlyColor)
	fighter_reckt_list[activePos].set_modulate(posColor)
	
	#yield(get_tree().create_timer(2), "timeout")
	activePos = fmod(activePos+1,teamSize)+4
	
	
