extends Control

signal ItemSet(item)

onready var slotList = [$M/VBoxContainer/InvEquipSlot1,$M/VBoxContainer/InvEquipSlot2]
var activeCharacter = null

func _ready():
	for i in range(slotList.size()):
		slotList[i].num = i

func set_active_state(state):
	for i in slotList:
		i.active = state

func set_equip(character):
	activeCharacter = character
	for i in range(0,slotList.size()):
		if(activeCharacter.equip.size() > i ):
			slotList[i].set_item(activeCharacter.equip[i])
			slotList[i].activeCaracter = character
		


func _on_Equip2_ItemSet(item,num):
	if activeCharacter.equip.size() > 1:
		activeCharacter.remove_item(item)
		activeCharacter.equip[1] = item
		activeCharacter.add_item(item)
		activeCharacter.calculate_all_stats()
		emit_signal("ItemSet",item)

func _on_Equip1_ItemSet(item,num):
	if activeCharacter.equip.size() > 0:
		activeCharacter.remove_item(item)
		activeCharacter.equip[0] = item
		activeCharacter.add_item(item)
		activeCharacter.calculate_all_stats()
		emit_signal("ItemSet",item)
