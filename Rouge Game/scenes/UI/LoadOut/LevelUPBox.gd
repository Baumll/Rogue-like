extends VBoxContainer

onready var TextContainer = $VBox/HBox/LevelUpBox

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	load_character(GameData.active_character)

func load_character(character):
	if character != null:
		get_child(0).text = ("Name: " + String(character.klass))
		get_child(1).text = ("Level: " + String(character.level))
		get_child(2).set_text("Health: " + String(character.health) +"/" + String(character.max_health))
		get_child(3).set_text("Armor: " + String(character.defence))
		get_child(4).set_text("Mag. Def.: " + String(character.magic_defence))
		get_child(5).set_text("Strength: " + String(character.strength))
		get_child(6).set_text("Magic: " + String(character.magic))
		get_child(7).set_text("Dexterity: " + String(character.dexterity))
		get_child(8).set_text("Speed: " + String(character.speed))
		if character.skill_points > 1:
			set_level_up(true)

func set_level_up(state):
	for i in self.get_children():
		if ! "Label" in i.name:
			i.set_level_up(state)


func _on_level_up_health():
	GameData.active_character.base_max_health += 5
	GameData.active_character.skill_points -= 1
	GameData.active_character.calculate_all_stats()
	GameData.active_character.reset_health()
	if GameData.active_character.skill_points <= 0:
		set_level_up(false)

func _on_level_up_defence():
	GameData.active_character.Base_Defence += 1
	GameData.active_character.skill_points -= 1
	GameData.active_character.calculate_all_stats()
	if GameData.active_character.skill_points <= 0:
		set_level_up(false)

func _on_level_up_magicDefence():
	GameData.active_character.base_magic_defence += 1
	GameData.active_character.skill_points -= 1
	GameData.active_character.calculate_all_stats()
	if GameData.active_character.skill_points <= 0:
		set_level_up(false)
		
func _on_level_up_strenght():
	GameData.active_character.base_strength += 1
	GameData.active_character.skill_points -= 1
	GameData.active_character.calculate_all_stats()
	if GameData.active_character.skill_points <= 0:
		set_level_up(false)

func _on_level_up_magic():
	GameData.active_character.base_magic += 1
	GameData.active_character.skill_points -= 1
	GameData.active_character.calculate_all_stats()
	if GameData.active_character.skill_points <= 0:
		set_level_up(false)

func _on_level_up_dexterity():
	GameData.active_character.base_dexterity += 1
	GameData.active_character.skill_points -= 1
	GameData.active_character.calculate_all_stats()
	if GameData.active_character.skill_points <= 0:
		set_level_up(false)

func _on_level_up_speed():
	GameData.active_character.base_speed += 1
	GameData.active_character.skill_points -= 1
	GameData.active_character.calculate_all_stats()
	if GameData.active_character.skill_points <= 0:
		set_level_up(false)
