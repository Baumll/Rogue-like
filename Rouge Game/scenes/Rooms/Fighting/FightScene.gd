extends Control

signal setCharActive(character)
signal endFight(chars,items,ep)
signal playSound(sound)
signal loadChars(chars)
signal useCharSelect(arg)
signal exit()

onready var blur = $Blur
onready var MoveAnimationPanel = $MoveAnimationPanel
onready var timeLine = $BigBox/FighterTimeLine
var preCombatAttackScript = preload("res://ScribtAble/CombatScrips/CombatScriptPreAttackOffence.gd")
var preCombatDefenseScript = preload("res://ScribtAble/CombatScrips/CombatScriptPreAttackDefence.gd")
var afterCombatDefenseScript = preload("res://ScribtAble/CombatScrips/CombatScriptAfterAttackDefense.gd")
var afterCombatAttackScript = preload("res://ScribtAble/CombatScrips/CombatScriptAfterAttackOffence.gd")

var rng = RandomNumberGenerator.new()


var fighter_list = Array()  #Ein 2D array mit der Liste der Kämpfer geilt in die Teams
var fighter_rect_list = Array()
var friendlyFighterCount = -1
var activeFighter
var selectedFighter = null #Der character der gerade unten angezeigt wird
var activeMove

var isAnimationPlaying = false #Ob gerade eine Animation spielt Achtunr geht nur wenn alle animationen gleichlang sind

var initative = [] #Schein meine Liste zu sein mit den Kämpfer die nach Momentum geordnet ist

var moves = [] # Eine Lsiter der Moves die der aktive champion nutzen kann
#var fighterTargetList = [] #Die Kämpfer die gerade anvisiert werden
var targetChooseMode = false

export(bool) var pacifism = true
export(int) var team_size = 4

var button_time_start = 0 #Die timer Ab wann das halten nicht mehr als klicken gezählt wird

var ep = 0 #Wie viel EP zwischend en Charaktären aufgeteilt wird

func _ready():
	preCombatAttackScript = preCombatAttackScript.new()
	preCombatDefenseScript = preCombatDefenseScript.new()
	afterCombatDefenseScript = afterCombatDefenseScript.new()
	afterCombatAttackScript = afterCombatAttackScript.new()
	
	setup_fight()
	start_fight()

# Called when the node enters the scene tree for the first time.
func setup_fight():
	#Set up the fighter List
	fighter_list = set_up_fighter_list()
	initative = []
	fighter_rect_list = find_CharacterContainer()
	for x in fighter_rect_list:
		x.set_health(0,0)
	#bekommt ein array [enemys,friends]
	var enemy_list = GlobalFunktions.pick_enemys()
	var powerlevel = GameData.power_level
	while enemy_list == []:
		powerlevel =+ 1
		enemy_list = GlobalFunktions.pick_enemys()
	var tmpArray = [enemy_list,GameData.heros]
	friendlyFighterCount = tmpArray[1].size()
	add_all_fighters(tmpArray)
	#add_all_fighters(tmpArray)
	emit_signal("loadChars",tmpArray[1])
	emit_signal("useCharSelect", true)

func start_fight():
	pacifism = false
	rng.randomize()
	for x in initative:
		get_fighter(x).momentum = 0
		update_health(x)
	next_round()
	for i in fighter_rect_list:
		i.set_selection(false)
	set_active_fighter(initative[0])
	button_time_start = 0


func end_fight(team):
	pacifism = true
	initative = []
	var chars = null
	if team == 1:
		chars = GameData.heros
	emit_signal("endFight",chars ,[], ep)

#Wenn Momemtum < 0
func next_round():
	print("next Round")
	for x in initative:
		get_fighter(x).momentum += get_fighter(x).speed
	initative.sort_custom(self, "customComparison")
	if(get_fighter(initative[0]).momentum <= 0):
		next_round()

func add_all_fighters(args):
	for i in range(0,args.size()):
		if args[i].size() >= 3:
			for j in range(0,args[i].size()):
				if(i == 1):
					add_fighter_spot(args[i][j],j+team_size)
				else:
					add_fighter_spot(args[i][j],j)
		else:
			for j in range(0,args[i].size()):
				if(i == 1):
					add_fighter_spot(args[i][j],j+team_size+1)
				else:
					add_fighter_spot(args[i][j],j+1)
					

#Fügt einen Fighter an ein
func add_fighter_spot(fighterObj, spot):
	fighter_list[spot] = fighterObj
	initative.append(spot)
	initative.sort_custom(self, "customComparison")
	update_fighter_image()
	update_health(spot)
	timeLine.set_order( set_time_line(initative), null)

func remove_fighter(num):
	if(num < team_size and get_fighter(num) != null):
		ep += get_fighter(num).death_exp
	fighter_list[num] = null
	initative = []
	for x in range(fighter_list.size()):
		if get_fighter(x) != null:
			initative.append(x)
	initative.sort_custom(self, "customComparison")
	update_fighter_image()
	update_health(num)
	timeLine.set_order( set_time_line(initative),null)

	var tmpFinish = true
	for i in range(0, team_size):
		if(get_fighter(i) != null):
			tmpFinish = false
		#Win
	if(tmpFinish):
		end_fight(1)
		return
	
	tmpFinish = true
	for i in range(team_size, team_size*2):
		if(get_fighter(i) != null):
			tmpFinish = false
		#Lose
	if(tmpFinish):
		end_fight(0)
		return


func set_active_fighter(num):
	yield(get_tree().create_timer(0.5), "timeout")
	#Warten Ende
	for i in fighter_rect_list:
		i.set_selection(false)
	print("Momentum: " + String(get_fighter(num).momentum))
	activeFighter = num
	get_fighter(num).iterate_status()
	if num < team_size: #Wenn ein gegner dran ist nutz eine zufällige attacke
		npc_move(activeFighter)
	else: #Wenn ein Verbündeter dran ist
		#emit_signal("loadAttacks", get_fighter(activeFighter).moves)
		emit_signal("setCharActive", get_fighter(activeFighter))
	fighter_rect_list[activeFighter].set_status_bar(get_fighter(activeFighter).status_list)
	fighter_rect_list[activeFighter].set_selection(true)

func get_fighter(num) -> Resource:
	if( fighter_list[num] != null):
		return fighter_list[num]
	else:
		return null




func get_fighter_container(num) -> Resource:
	if( fighter_rect_list[num] != null):
		return fighter_rect_list[num]
	else:
		return null

#der move wird aufgeführt  Animation kommt noch dazu
func press_move_button(move):
	if selectedFighter == get_fighter(activeFighter):
		targetChooseMode = false
		if pacifism == false: 
			emit_signal("loadAttacks", null)
			var fighterTargetList = select_targets(move)
			#Wenn die Attacke zum Auswählen ist:
			if(move.targets == move.target_kinds.choose_enemy or  move.targets == move.target_kinds.choose_friend):
				targetChooseMode = true
				activeMove = move
				for x in select_targets(move):
					get_fighter_container(x).set_selection(true)
				return
			make_move(move, fighterTargetList)
			#Wenn ausgewählt wurde

func npc_move(npc):
	#Wenn er kein Move hat
	if get_fighter(npc).moves.size() == 0:
		print("KEINE MOVES")
		var dummy_move = load("res://Units/Attacks/MoveDummy.tres")
		var fighterTargetList = select_targets(dummy_move)
		make_move(dummy_move, fighterTargetList)
		return
	#Macht einen Zufälligen Move
	var num = rng.randi_range(0,get_fighter(npc).moves.size()-1)
	while get_fighter(npc).moves[num] == null:
		num = rng.randi_range(0,get_fighter(npc).moves.size()-1)
	var fighterTargetList = select_targets(get_fighter(npc).moves[num])
	make_move(get_fighter(npc).moves[num], fighterTargetList)

func make_move(move, fighterTargetList):
	if fighterTargetList.size() > 0:
		#DMG/Heal Calculation:
		#Sammelt die Images für Animation
		var animationImages = [get_fighter(activeFighter).image]
		var dmgValues = []
		for x in fighterTargetList:
			if(get_fighter(x) != null):
				animationImages.append(get_fighter(x).image)
				dmgValues.append(use_move_on_fighter(x,activeFighter,move))
		blur.material.set_shader_param("blur", 4.0)
		MoveAnimationPanel.load_images(animationImages, floor(activeFighter/team_size))
		MoveAnimationPanel.play_Move(move, dmgValues)
		yield( MoveAnimationPanel, "animation_finished" )
		blur.material.set_shader_param("blur", 0.0)
		
	#Schaut ob wer stirbt
	fighterTargetList.append(activeFighter)
	for x in fighterTargetList:
		if(get_fighter(x).health <= 0):
			remove_fighter(x)
			
	#Next turn und so
	get_fighter(activeFighter).momentum -= move.cost
	initative.sort_custom(self, "customComparison")
	if initative.size() > 0:
		if get_fighter(initative[0]).momentum > 0:
			set_active_fighter(initative[0])
			return
		next_round()
		set_active_fighter(initative[0])
		timeLine.set_order(set_time_line(initative),null)
	else:
		for i in fighterTargetList:
			fighter_rect_list[i].set_selection(true)

func set_time_line(list) -> Array:
	var out = []
	for i in list:
		out.append(fighter_list[i])
	return out


#Bestimmt die Ziele:
func select_targets(move):
	var tmp_target_list = []
	match move.targets:
		move.target_kinds.choose_enemy:
			if( activeFighter < team_size):
				tmp_target_list.append(4)
				tmp_target_list.append(5)
				tmp_target_list.append(6)
				tmp_target_list.append(7)
			else:
				tmp_target_list.append(0)
				tmp_target_list.append(1)
				tmp_target_list.append(2)
				tmp_target_list.append(3)
				
		move.target_kinds.choose_friend:
			if( activeFighter >= team_size):
				tmp_target_list.append(4)
				tmp_target_list.append(5)
				tmp_target_list.append(6)
				tmp_target_list.append(7)
			else:
				tmp_target_list.append(0)
				tmp_target_list.append(1)
				tmp_target_list.append(2)
				tmp_target_list.append(3)
		move.target_kinds.in_front:
			tmp_target_list.append(fmod(activeFighter+team_size, team_size*2))
		move.target_kinds.adjacent_enemy:
			var min_target = fmod(activeFighter+team_size, team_size*2)-1
			if(min_target < 0):
				min_target = 0
			if (activeFighter < team_size && min_target < team_size):
				min_target = team_size
			var max_target = fmod(activeFighter+team_size, team_size*2)+1
			if(max_target >= team_size*2):
				max_target = team_size*2 -1
			if (activeFighter >= team_size && max_target > team_size):
				max_target = team_size-1
			for i in range(min_target,max_target+1):
				tmp_target_list.append(i)
		
		move.target_kinds.all_enemy:
			if( activeFighter < team_size):
				tmp_target_list.append(4)
				tmp_target_list.append(5)
				tmp_target_list.append(6)
				tmp_target_list.append(7)
			else:
				tmp_target_list.append(0)
				tmp_target_list.append(1)
				tmp_target_list.append(2)
				tmp_target_list.append(3)
		move.target_kinds.me:
			tmp_target_list.append(activeFighter)
			
		move.target_kinds.all_team_other:
			match activeFighter:
				0:
					tmp_target_list.append(1)
					tmp_target_list.append(2)
					tmp_target_list.append(4)
				1:
					tmp_target_list.append(0)
					tmp_target_list.append(2)
					tmp_target_list.append(3)
				2:
					tmp_target_list.append(1)
					tmp_target_list.append(0)
					tmp_target_list.append(3)
				3:
					tmp_target_list.append(0)
					tmp_target_list.append(1)
					tmp_target_list.append(2)
				4:
					tmp_target_list.append(5)
					tmp_target_list.append(6)
					tmp_target_list.append(7)
				5:
					tmp_target_list.append(4)
					tmp_target_list.append(6)
					tmp_target_list.append(7)
				6:
					tmp_target_list.append(4)
					tmp_target_list.append(5)
					tmp_target_list.append(7)
				7:
					tmp_target_list.append(4)
					tmp_target_list.append(5)
					tmp_target_list.append(6)
		move.target_kinds.all_team:
			if activeFighter < team_size:
				tmp_target_list.append(0)
				tmp_target_list.append(1)
				tmp_target_list.append(2)
				tmp_target_list.append(3)
			else:
				tmp_target_list.append(4)
				tmp_target_list.append(5)
				tmp_target_list.append(6)
				tmp_target_list.append(7)
	var returnList = []
	for x in tmp_target_list:
		if get_fighter(x) != null:
			returnList.append(x)
	return returnList

#0 = physisch
#1 = magisch
#2 = heal
func use_move_on_fighter(target, source, move):
	print(get_fighter(source).klass + " used " + move.name + " on " + get_fighter(target).klass)
	var target2 = get_fighter(target)
	var source2 = get_fighter(source)
	var target3 = copy_fighter(target2)
	var source3 = copy_fighter(source2)
	var move3 = copyMove(move)
	
	#Hier kommen die Pre Combat Effekte
	for i in source3.status_list:
		if i.status_type == 3: #combat
			if(i.preMove != null):
				if preCombatAttackScript.has_method(i.preMove):
					preCombatAttackScript.call(i.preMove,target3,source3,move3)
				else:
					print("Warning: PreCombatAttack Source method: " + i.preMove + " dose not exist")
	for i in target3.status_list:
		if i.status_type == 3: #combat
			if(i.preMove != null):
				if preCombatDefenseScript.has_method(i.preMove):
					preCombatDefenseScript.call(i.preMove,target3,source3,move3)
				else:
					print("Warning: PreCombatDefense Source method: " + i.preMove + "dose not exist")
	
	
	var rtn = []
	if move.physical_dmg > 0:
		rtn.append(target2.get_magic_dmg(floor(move3.physical_dmg + source3.strength -source3.defence)))
		source2.has_dealt_magic(rtn[0])
	else:
		rtn.append(0)
	if move.magical_dmg > 0:
		var mgc_dmg = target2.get_dmg(floor(move3.magical_dmg + source3.magic -source3.magic_defence))
		rtn.append(mgc_dmg)
		source2.has_dealt_physical(rtn[1])
	else:
		rtn.append(0)
	if move.heal > 0:
		rtn.append((target2.get_heal(floor(move3.heal*(1+source3.heal_procent)))))
		source2.has_healed(rtn[2])
	else:
		rtn.append(0)
		
	#Hier kommen die After Combat Effekte
	for i in source3.status_list:
		if i.status_type == 3: #combat
			if(i.preMove != null):
				if afterCombatDefenseScript.has_method(i.preMove):
					afterCombatDefenseScript.call(i.preMove,target3,source3,move3)
				else:
					print("Warning: AfterCombatDefense Source method: " + i.preMove + " dose not exist")
	for i in target3.status_list:
		if i.status_type == 3: #combat
			if(i.preMove != null):
				if afterCombatAttackScript.has_method(i.preMove):
					afterCombatAttackScript.preMove(target3,source3,move3)
				else:
					print("Warning: AfterCombatAttack Source method: " + i.preMove + "dose not exist")
	buff(target, move.status)
	update_health(target)
	update_health(source)
	return rtn


func copy_fighter(fighter):
	var newFighter = GlobalFunktions.load_character(fighter)
	return newFighter

func copyMove(move):
	var newMove = GlobalFunktions.get_move(move.name)
	return newMove

#Spielt die Animation bei kämpfer num von move ab OLD
func play_move_animation(num, move):
	if (move.animation != null):
		print("Animation Started")
		fighter_rect_list[num].play_animation(move.animation)




func buff(fighter, status):
	if(status != null):
		#status = status.new()
		status.turns = status.max_turns
		print("buff")
		get_fighter(fighter).append_status(status)
		fighter_rect_list[fighter].set_status_bar(get_fighter(fighter).status_list)
		update_health(fighter)



func update_health(num):
	if(get_fighter(num) != null):
		fighter_rect_list[num].set_health(get_fighter(num).max_health,get_fighter(num).health)
	else:
		fighter_rect_list[num].set_health(0,0)



func update_fighter_image():
	for x in range(fighter_list.size()):
		if get_fighter(x) != null:
			fighter_rect_list[x].set_image(get_fighter(x).image)
			fighter_rect_list[x].visible = true
		else:
			fighter_rect_list[x].set_image(null)
			#fighter_rect_list[x].visible = false


#Die Funtionen auf die einzelnen Kämpfer:
func kill(unit):
	remove_fighter(unit)


func refresh(fighter):
	get_fighter(fighter).health = get_fighter(fighter).max_health


#Other use full functions:

func customComparison(a,b):
	if typeof(a) != typeof(b):
		return typeof(a) > typeof(b)
	else:
		return get_fighter(a).momentum > get_fighter(b).momentum


func find_CharacterContainer() -> Array:
	var new_fighter_rect_list = []
	new_fighter_rect_list.append($BigBox/FR/C)
	new_fighter_rect_list.append($BigBox/FR/V2/C2)
	new_fighter_rect_list.append($BigBox/FR/V3/C3)
	new_fighter_rect_list.append($BigBox/FR/V4/C4)
	
	new_fighter_rect_list.append($BigBox/FR2/C5)
	new_fighter_rect_list.append($BigBox/FR2/V2/C6)
	new_fighter_rect_list.append($BigBox/FR2/V3/C7)
	new_fighter_rect_list.append($BigBox/FR2/V4/C8)
	return new_fighter_rect_list



func set_up_fighter_list() -> Array:
	var fighterListt = []
	for _i in range(team_size*2):
		fighterListt.append(null)
	return fighterListt


func _on_BigBox_down(num):
	pass # Replace with function body.


func _on_BigBox_up(num):
	print("BigBoxUP")
	if targetChooseMode:
		if select_targets(activeMove).has(num):
			targetChooseMode = false
			make_move(activeMove, [num] )


func _on_AnimatedSprite_animation_finished():
	pass # Replace with function body.


func _on_AttackButtons_attackDown(num):
	#TO:DO Zeigen in Time Line
	#TO:DO Ziele Zeigen
	#Fängt ab wenn mehere Knöpfe gleichzeitig gedrückt wurden
	if(targetChooseMode == false and !pacifism):
		if(button_time_start == 0):
			button_time_start = OS.get_ticks_msec()
			#Ziele Zeigen
			if(get_fighter(activeFighter).moves.size() > num):
				var targets = select_targets(get_fighter(activeFighter).moves[num])
				timeLine.set_order(set_time_line(initative), get_fighter(activeFighter).moves[num],get_fighter(activeFighter).icon)
				for i in targets:
					fighter_rect_list[i].set_selection(true)
		else:
			button_time_start = -1
	


func _on_AttackButtons_attackUP(num):
	if(targetChooseMode == false):
		for i in fighter_rect_list:
			i.set_selection(false)
	if(button_time_start > 0):
		var button_time_now = OS.get_ticks_msec()
		#Müsste eine Halbe secunde sein
		timeLine.set_order(set_time_line(initative), null)
		if (num != -1 and (button_time_now-button_time_start)/100 < 5):
			if !pacifism: 
				if(get_fighter(activeFighter).moves.size() > num):
					press_move_button(get_fighter(activeFighter).moves[num])
	button_time_start = 0




func _on_MoveAnimationPanel_playSound(sound):
	emit_signal("playSound", sound)




func _on_Ui_Under_selected_character(character):
	selectedFighter = character


func _on_FightEnd_exit():
	emit_signal("exit")
