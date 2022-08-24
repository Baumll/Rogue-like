extends Node

var rng = RandomNumberGenerator.new()
var source


export(String) var description = ""
export(StreamTexture) var icon = null
export(int) var value = 10
export(Resource) var status = null
var rarity = null


func load_stats(data):
	if typeof(data) == TYPE_DICTIONARY:
		name = data["Name"]
		description = data["Description"]
		value = data["Value"]
		icon = load(data["Icon"])
		rarity = data["Rarity"]
		status = GlobalFunktions.get_status(data["Status"])

func to_dictonary():
	var dic = {}
	dic["Name"] = name
	dic["Description"] = description
	dic["Value"] = value
	dic["Icon"] = icon.resource_path
	dic["Rarity"] = rarity
	dic["Status"] = status.name
	return dic
