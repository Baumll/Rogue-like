extends VBoxContainer

signal exit()
signal load_out()

onready var movebox = $VBox
export(int) var heros_to_buy = 2
var hero_buy_list = []

var char_selecet = preload("res://scenes/Rooms/mentor/four_select.tscn")

func calc_hero_value(hero):
	if typeof(hero) == TYPE_DICTIONARY:
		return 3 + hero['Level'] * 9
	else:
		return 3 + hero.level * 9

func _ready():
	setup()
		
	
func setup():
	var min_level = 0
	var max_level = 9000
	for hero in GameData.heros:
		if max_level < hero.level :
			max_level = hero.level 
		if min_level > hero.level :
			min_level = hero.level 
	var hero_list = GlobalFunktions.get_hero_list()
	for hero in hero_list:
		if hero['Level'] > max_level:
			hero_list.remove(hero)
		if hero['Level']  < (min_level-1):
			hero_list.remove(hero)
	for i in range(heros_to_buy):
		var hero = hero_list[GlobalFunktions.rng.randi_range(0,hero_list.size()-1)]
		hero_buy_list.append(hero)
		movebox.get_child(i).set_hero(hero, calc_hero_value(hero))

func _on_learn(hero):
	for hero in GameData.heros:
		hero.holy += 10
	emit_signal("exit")

func _on_ButtonRight_button_up():
	emit_signal("exit")

func button_bought(hero):
	if GameData.heros.size() < GlobalFunktions.team_size:
		if GameData.gold > calc_hero_value(hero):
			hero = GlobalFunktions.load_character(hero)
			GameData.heros.append(hero)
			movebox.get_child(hero_buy_list.find(hero))
			GameData.gold -= calc_hero_value(hero)
			

func _on_Button_pressed(hero):
	button_bought(hero)

func _on_button_sell():
	if GameData.heros.size() > 1:
		var four_select = char_selecet.instance()
		add_child(four_select)
		four_select.load_heros(GameData.heros)
		four_select.connect("selected", self, "on_hero_select")

func on_hero_select(hero):
	if hero:
		GameData.heros.remove(GameData.heros.find(hero))
		GameData.gold += calc_hero_value(hero)/2
	get_child(get_child_count()-1).queue_free()


func _on_Button_exit():
	emit_signal('exit')

func _on_Button2_load_out():
	emit_signal('load_out')


