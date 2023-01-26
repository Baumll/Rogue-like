extends Control

signal ItemSet(item)

onready var slotList = [$M/VBoxContainer/InvEquipSlot1,$M/VBoxContainer/InvEquipSlot2]
var activeCharacter = null

func _ready():
	for i in range(slotList.size()):
		slotList[i].num = i

func _process(delta):
	set_equip(GameData.active_character)

func set_active_state(state):
	for i in slotList:
		i.active = state

func set_equip(character):
	#Setzt die ausgerüsteten Item in die Equip slots
	if character:
		activeCharacter = character
		for i in range(0,slotList.size()):
			if activeCharacter.equip.size()-1 >= i:
				slotList[i].activeCaracter = character
				slotList[i].set_item(activeCharacter.equip[i])
			else:
				slotList[i].activeCaracter = character
				slotList[i].set_item(null)


func _on_ItemSet(item):
	emit_signal("ItemSet",item)
	pass
