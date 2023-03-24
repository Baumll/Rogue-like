extends Control

signal exit(room)
signal load_out()

onready var leftDoor = $HBox/ButtonLeft
onready var rightDoor = $HBox/ButtonRight
var rooms = []

# Called when the node enters the scene tree for the first time.
func _ready():
	GameData.room = 'Door'
	rooms = [get_room(),get_room()]
	setup_doors(load(rooms[0][1]),load(rooms[1][1]))

func setup_doors(left, right):
	leftDoor.icon = left
	rightDoor.icon = right

func get_room(): 
	var room_list = []
	room_list.append(["res://scenes/Rooms/Heal/HealRoom.tscn","res://Assets/images/Icons/Rooms/green_14.PNG"])
	room_list.append(["res://scenes/Rooms/Fighting/FightScene.tscn","res://Assets/images/Icons/Rooms/blue_12.png"])
	room_list.append(["res://scenes/Rooms/merchant/merchantScene.tscn","res://Assets/images/Icons/Rooms/gray_07.PNG"])
	room_list.append(["res://scenes/Rooms/Item/ItemRoom.tscn","res://Assets/images/Icons/Rooms/TradingIcons_08.png"])
	room_list.append(["res://scenes/Rooms/shrine/Shrine.tscn","res://Assets/images/rooms/schrine/shrine.png"])
	room_list.append(["res://scenes/Rooms/mentor/mentor.tscn","res://Assets/images/rooms/mentor/MentorImage.png"])
	room_list.append(["res://scenes/Rooms/slave_trader/SlaveTrader.tscn","res://Assets/images/rooms/slave_trader/slave_trader.jpg"])
	#Room spawn chance
	var chance = [2,2,2,2,2,2,2]
	var sum = 0
	for i in chance:
		sum += i
	var room = GlobalFunktions.rng.randi_range(0,sum-1)
	var sum2 = 0
	for i in range(len(chance)):
		sum2 += chance[i]
		if room < sum2:
			 return room_list[i]

func _on_ButtonLeft_pressed():
	emit_signal("exit",rooms[0][0])


func _on_ButtonRight_pressed():
	emit_signal("exit",rooms[1][0])


func _on_Button_button_up():
	emit_signal("load_out")
