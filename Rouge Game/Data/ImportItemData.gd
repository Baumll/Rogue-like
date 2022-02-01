extends Node

var item_data

func _ready():
	var itemData_File = File.new()
	itemData_File.open("res://Data/ItemTable.json", File.READ)
	var itemData_Json = JSON.parse(itemData_File.get_as_text())
	itemData_File.close()
	item_data = itemData_Json.result
	#if item_data.error != OK:
		#printerr("Jason ist nicht correkt!")
	JSON.print(item_data, "\t")
