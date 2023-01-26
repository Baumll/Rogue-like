extends Node

onready var loadout_scene = $LoadOut
var door_scene = 'res://scenes/Rooms/door/DoorScene.tscn'

# Called when the node enters the scene tree for the first time.
func _ready():
	#Load Data
	GlobalFunktions.set_up_rng()
	GlobalFunktions.load_item_list()
	GlobalFunktions.load_enemy_list()
	GlobalFunktions.load_move_list()

func _process(_delta):
	pass

#Loads a new room to child posion 0
func _on_enter_room(room = null):
	get_child(0).queue_free()
	if not room:
		#Load the Door scene if no room given
		room = 'res://scenes/Rooms/door/DoorScene.tscn'
	var loaded_room = load(room)
	var instance_room = loaded_room.instance()
	add_child(instance_room)
	move_child(instance_room, 0)
	#Connect Siganls
	instance_room.connect('exit',self,"_on_enter_room")
	instance_room.connect('load_out',self,"_on_enter_loadOut")
	
	GameData.power_level += 1

func _on_enter_loadOut():
	loadout_scene.visible = true

func _on_exit_loadout():
	loadout_scene.visible = false
