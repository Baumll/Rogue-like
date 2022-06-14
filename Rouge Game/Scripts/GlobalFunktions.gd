extends Node

var teamSize = 4
var equipSize = 2

var save_dir = "user://save/"
var save_file = save_dir + "rough.save" #Der Pfad wo gespeichert wird
var password = "BitteDenkeDirEinsAus"

var move_path = "res://Units/Attacks/"
var equip_path = "res://Units/Items/"
var status_path = "res://Units/States/"


var rng = null

func set_up_rng(rngSeed = ""):
	rng = RandomNumberGenerator.new()
	if rngSeed == "":
		rng.randomize()
	else:
		rng.seed = hash(rngSeed)

func create_floaty_text(amount, position, color = Color('33040b') ):
	if(amount != null):
		var floaty_text_scene = load("res://scenes/UI/Fighting/Floating_Text.tscn")
		var floaty_text = floaty_text_scene.instance()
		
		floaty_text.position = position #Vector2(480/2, 270/2)
		floaty_text.velocity = Vector2(rand_range(-100, 100), -200)
		floaty_text.modulate = color#Color(rand_range(0.7, 1), rand_range(0.7, 1), rand_range(0.7, 1), 1.0)
		### White
		#floaty_text.modulate = Color(1.0, 1.0, 1.0, 1.0)
		#var amount = randi()%10 - 5
		floaty_text.text = amount
		
		if amount > 0:
			floaty_text.text = floaty_text.text
		add_child(floaty_text)

#Zum laden der Json datei mit den Charateren
func load_characters():
	#Hier werden die verfügbaren charactere geladen.
	#Read Data
	var file = File.new()
	file.open("res://csv/Characters.json", file.READ)
	var data_cdb = parse_json(file.get_as_text())
	file.close()
	
	#Extract Data
	for sheet in data_cdb["sheets"]:
		if sheet["name"] == "CharacterList":
			var sorted_dict={}
			for entry in sheet["lines"]:
				var new_entry = entry.duplicate()
				new_entry.erase("Name")
				sorted_dict[entry["Name"]] = new_entry
			return sorted_dict
	return null
