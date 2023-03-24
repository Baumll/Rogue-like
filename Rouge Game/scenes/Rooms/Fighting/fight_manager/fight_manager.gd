extends Node2D

signal exit()
signal fight_end()

# Declare member variables here. Examples:
# var a = 2
onready var fight = $FightScene
onready var reward = $FightEnd


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_FightScene_exit(team):
	#1 = win; 0 = lose
	if team == 1:
		reward.visible = true
		emit_signal("fight_end",[], 100)
	else:
		get_tree().reload_current_scene()


func _on_FightEnd_exit():
	emit_signal("exit")
