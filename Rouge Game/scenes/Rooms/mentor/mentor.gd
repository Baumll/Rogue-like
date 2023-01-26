extends VBoxContainer

signal exit()
signal load_out()

onready var movebox = $VBox
export(int) var moves_to_buy = 3
var moves_buy_list = []
var selected_move = null
var selected_hero = null

var char_selecet = preload("res://scenes/Rooms/mentor/four_select.tscn")

func calc_value(move):
	return (5 + move.level * 5)

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
	var move_list = GlobalFunktions.get_move_list()
	for move in move_list:
		if move.level > max_level:
			move_list.remove(move)
		if move.level  < (min_level-1):
			move_list.remove(move)
	for i in range(moves_to_buy):
		var move = move_list[GlobalFunktions.rng.randi_range(0,move_list.size()-1)]
		moves_buy_list.append(move)
		movebox.get_child(i).set_move(move, calc_value(move))


func on_hero_select(hero):
	if hero:
		if !hero.knows_move(selected_move):
			if hero.moves.size() < 4:
				get_child(get_child_count()-1).queue_free()
				hero.moves.append(selected_move)
				movebox.get_child(moves_buy_list.find(selected_move)).disable()
				moves_buy_list[moves_buy_list.find(selected_move)] == null
				GameData.gold -= calc_value(selected_move)
			else:
				get_child(get_child_count()-1).queue_free()
				selected_hero = hero
				var four_select = char_selecet.instance()
				add_child(four_select)
				four_select.load_moves(selected_hero.moves)
				four_select.connect("selected", self, "_on_move_forget")
		else:
			return
	else:
		get_child(get_child_count()-1).queue_free()


func _on_move_forget(move):
	get_child(get_child_count()-1).queue_free()
	if move:
		selected_hero.moves[selected_hero.moves.find(move)] = selected_move
		var move_position = moves_buy_list.find(selected_move)
		movebox.get_child(move_position).disable()
		moves_buy_list[move_position] == null
		GameData.gold -= calc_value(move)
	else:
		var four_select = char_selecet.instance()
		add_child(four_select)
		four_select.load_heros(GameData.heros)
		four_select.connect("selected", self, "on_hero_select")


func _on_ButtonRight_button_up():
	emit_signal("exit")

func button_bought(move):
	if moves_buy_list.find(move) != -1:
		if GameData.gold > calc_value(move):
			selected_move = move
			var four_select = char_selecet.instance()
			add_child(four_select)
			four_select.load_heros(GameData.heros)
			four_select.connect("selected", self, "on_hero_select")

func _on_Button_pressed(move):
	button_bought(move)

func _on_button_sell():
	pass

func _on_Button_exit():
	emit_signal('exit')

func _on_Button2_load_out():
	emit_signal('load_out')


