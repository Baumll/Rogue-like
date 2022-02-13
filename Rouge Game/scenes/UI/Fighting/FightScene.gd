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
var preFighter = preload("res://ScribtAble/ClassChracter.gd")
var preMove = preload("res://ScribtAble/ClassMove.gd")
var preCombatAttackScript = preload("res://ScribtAble/CombatScrips/CombatScriptPreAttackOffence.gd")
var preCombatDefenseScript = preload("res://ScribtAble/CombatScrips/CombatScriptPreAttackDefence.gd")
var afterCombatDefenseScript = preload("res://ScribtAble/CombatScrips/CombatScriptAfterAttackDefense.gd")
var afterCombatAttackScript = preload("res://ScribtAble/CombatScrips/CombatScriptAfterAttackOffence.gd")

var rng = RandomNumberGenerator.new()


var fighterList = Array()  #Ein 2D array mit der Liste der Kämpfer geilt in die Teams
var fighterRectList = Array()
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
export(int) var teamSize = 4

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
	fighterList = set_up_fighter_list()
	initative = []
	fighterRectList = find_CharacterContainer()
	for x in fighterRectList:
			x.set_health(0,0)
	#bekommt ein array [enemys,friends]
	var tmpArray = get_node("/root/Main").load_characters_fight()
	friendlyFighterCount = tmpArray[1].size()
	add_all_fighters(tmpArray)
	#add_all_fighters(tmpArray)
	emit_signal("loadChars",tmpArray[1])
	emit_signal("useCharSelect", false)

func start_fight():
	pacifism = false
	rng.randomize()
	for x in initative:
		get_fighter(x).momentum = 0
		update_health(x)
	next_round()
	for i in fighterRectList:
		i.set_selection(false)
	set_active_fighter(initative[0])
	button_time_start = 0


func end_fight(team):
	pacifism = true
	initative = []
	#for x in fighterRectList:
	#	x = null
	#for x in fighterRectList:
	#	x.set_health(0,0)
	var chars = null
	if team == 1:
		chars = get_node("/root/Main").characterList
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
					add_fighter_spot(args[i][j],j+teamSize)
				else:
					add_fighter_spot(args[i][j],j)
		else:
			for j in range(0,args[i].size()):
				if(i == 1):
					add_fighter_spot(args[i][j],j+teamSize+1)
				else:
					add_fighter_spot(args[i][j],j+1)
					

#Fügt einen Fighter an ein
func add_fighter_spot(fighterObj, spot):
	fighterList[spot] = fighterObj
	initative.append(spot)
	initative.sort_custom(self, "customComparison")
	update_fighter_image()
	update_health(spot)
	timeLine.set_order( set_time_line(initative), null)

func remove_fighter(num):
	if(num < teamSize and get_fighter(num) != null):
		ep += get_fighter(num).deathExp
	fighterList[num] = null
	initative = []
	for x in range(fighterList.size()):
		if get_fighter(x) != null:
			initative.append(x)
	initative.sort_custom(self, "customComparison")
	update_fighter_image()
	update_health(num)
	timeLine.set_order( set_time_line(initative),null)

	var tmpFinish = true
	for i in range(0, teamSize):
		if(get_fighter(i) != null):
			tmpFinish = false
		#Lose
	if(tmpFinish):
		end_fight(1)
		return
	
	tmpFinish = true
	for i in range(teamSize, teamSize*2):
		if(get_fighter(i) != null):
			tmpFinish = false
		#Win
	if(tmpFinish):
		end_fight(0)
		return


func set_active_fighter(num):
	yield(get_tree().create_timer(0.5), "timeout")
	#Warten Ende
	for i in fighterRectList:
		i.set_selection(false)
	print("Momentum: " + String(get_fighter(num).momentum))
	activeFighter = num
	get_fighter(num).iterate_status()
	if num < teamSize: #Wenn ein gegner dran ist nutz eine zufällige attacke
		npc_move(activeFighter)
	else: #Wenn ein Verbündeter dran ist
		#emit_signal("loadAttacks", get_fighter(activeFighter).moves)
		emit_signal("setCharActive", get_fighter(activeFighter))
	fighterRectList[activeFighter].set_status_bar(get_fighter(activeFighter).statusList)
	fighterRectList[activeFighter].set_selection(true)

func get_fighter(num) -> Resource:
	if( fighterList[num] != null):
		return fighterList[num]
	else:
		return null




func get_fighter_container(num) -> Resource:
	if( fighterRectList[num] != null):
		return fighterRectList[num]
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
			if(move.targets == move.target_kinds.chooseEnemy or  move.targets == move.target_kinds.chooseFriend):
				targetChooseMode = true
				activeMove = move
				for x in select_targets(move):
					get_fighter_container(x).set_selection(true)
				return
			make_move(move, fighterTargetList)
			#Wenn ausgewählt wurde

func npc_move(npc):
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
		MoveAnimationPanel.load_images(animationImages, floor(activeFighter/teamSize))
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
			fighterRectList[i].set_selection(true)

func set_time_line(list) -> Array:
	var out = []
	for i in list:
		out.append(fighterList[i])
	return out


#Bestimmt die Ziele:
func select_targets(move):
	var tempTargetList = []
	match move.targets:
		move.target_kinds.chooseEnemy:
			if( activeFighter < teamSize):
				tempTargetList.append(4)
				tempTargetList.append(5)
				tempTargetList.append(6)
				tempTargetList.append(7)
			else:
				tempTargetList.append(0)
				tempTargetList.append(1)
				tempTargetList.append(2)
				tempTargetList.append(3)
				
		move.target_kinds.chooseFriend:
			if( activeFighter >= teamSize):
				tempTargetList.append(4)
				tempTargetList.append(5)
				tempTargetList.append(6)
				tempTargetList.append(7)
			else:
				tempTargetList.append(0)
				tempTargetList.append(1)
				tempTargetList.append(2)
				tempTargetList.append(3)
		move.target_kinds.inFront:
			tempTargetList.append(fmod(activeFighter+teamSize, teamSize*2))
		move.target_kinds.adjacentEnemy:
			var mintarget = fmod(activeFighter+teamSize, teamSize*2)-1
			if(mintarget < 0):
				mintarget = 0
			if (activeFighter < teamSize && mintarget < teamSize):
				mintarget = teamSize
			var maxtarget = fmod(activeFighter+teamSize, teamSize*2)+1
			if(maxtarget >= teamSize*2):
				maxtarget = teamSize*2 -1
			if (activeFighter >= teamSize && maxtarget > teamSize):
				maxtarget = teamSize-1
			for i in range(mintarget,maxtarget+1):
				tempTargetList.append(i)
		
		move.target_kinds.allEnemy:
			if( activeFighter < teamSize):
				tempTargetList.append(4)
				tempTargetList.append(5)
				tempTargetList.append(6)
				tempTargetList.append(7)
			else:
				tempTargetList.append(0)
				tempTargetList.append(1)
				tempTargetList.append(2)
				tempTargetList.append(3)
		move.target_kinds.me:
			tempTargetList.append(activeFighter)
			
		move.target_kinds.allTeamOther:
			match activeFighter:
				0:
					tempTargetList.append(1)
					tempTargetList.append(2)
					tempTargetList.append(4)
				1:
					tempTargetList.append(0)
					tempTargetList.append(2)
					tempTargetList.append(3)
				2:
					tempTargetList.append(1)
					tempTargetList.append(0)
					tempTargetList.append(3)
				3:
					tempTargetList.append(0)
					tempTargetList.append(1)
					tempTargetList.append(2)
				4:
					tempTargetList.append(5)
					tempTargetList.append(6)
					tempTargetList.append(7)
				5:
					tempTargetList.append(4)
					tempTargetList.append(6)
					tempTargetList.append(7)
				6:
					tempTargetList.append(4)
					tempTargetList.append(5)
					tempTargetList.append(7)
				7:
					tempTargetList.append(4)
					tempTargetList.append(5)
					tempTargetList.append(6)
		move.target_kinds.allTeam:
			if activeFighter < teamSize:
				tempTargetList.append(0)
				tempTargetList.append(1)
				tempTargetList.append(2)
				tempTargetList.append(3)
			else:
				tempTargetList.append(4)
				tempTargetList.append(5)
				tempTargetList.append(6)
				tempTargetList.append(7)
	var returnList = []
	for x in tempTargetList:
		if get_fighter(x) != null:
			returnList.append(x)
	return returnList

#0 = physisch
#1 = magisch
#2 = heal
func use_move_on_fighter(target, source, move):
	var target2 = get_fighter(target)
	var source2 = get_fighter(source)
	var target3 = copy_fighter(target2)
	var source3 = copy_fighter(source2)
	var move3 = copyMove(move)
	
	#Hier kommen die Pre Combat Effekte
	for i in source3.statusList:
		if i.statusTyp == 3: #combat
			if(i.preMove != null):
				if preCombatAttackScript.has_method(i.preMove):
					preCombatAttackScript.call(i.preMove,target3,source3,move3)
				else:
					print("Warning: PreCombatAttack Source method: " + i.preMove + " dose not exist")
	for i in target3.statusList:
		if i.statusTyp == 3: #combat
			if(i.preMove != null):
				if preCombatDefenseScript.has_method(i.preMove):
					preCombatDefenseScript.preMove(target3,source3,move3)
				else:
					print("Warning: PreCombatDefense Source method: " + i.preMove + "dose not exist")
	
	
	var rtn = []
	if move.physicalDmg > 0:
		rtn.append(target2.get_magic_dmg(floor(move3.physicalDmg + source3.strength -source3.defence)))
		source2.has_dealt_magic(rtn[0])
	if move.magicalDmg > 0:
		rtn.append(target2.get_dmg(floor(move3.magicalDmg + source3.magic -source3.magicDefence)))
		source2.has_dealt_physical(rtn[1])
	if move.heal > 0:
		rtn.append((target2.get_heal(floor(move3.heal*(1+source3.healProcent)))))
		source2.has_healed(rtn[2])
	
	#Hier kommen die After Combat Effekte
	for i in source3.statusList:
		if i.statusTyp == 3: #combat
			if(i.preMove != null):
				if afterCombatDefenseScript.has_method(i.preMove):
					afterCombatDefenseScript.call(i.preMove,target3,source3,move3)
				else:
					print("Warning: AfterCombatDefense Source method: " + i.preMove + " dose not exist")
	for i in target3.statusList:
		if i.statusTyp == 3: #combat
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
	var newFighter = preFighter.new()
	newFighter.loadStats(fighter)
	return newFighter

func copyMove(move):
	var newMove = preMove.new()
	newMove.load_move(move)
	return newMove

#Spielt die Animation bei kämpfer num von move ab OLD
func play_move_animation(num, move):
	if (move.animation != null):
		print("Animation Started")
		fighterRectList[num].play_animation(move.animation)




func buff(fighter, status):
	if(status != null):
		#status = status.new()
		status.turns = status.maxTurns
		print("buff")
		get_fighter(fighter).append_status(status)
		fighterRectList[fighter].set_status_bar(get_fighter(fighter).statusList)
		update_health(fighter)



func update_health(num):
	if(get_fighter(num) != null):
		fighterRectList[num].set_health(get_fighter(num).maxHealth,get_fighter(num).health)
	else:
		fighterRectList[num].set_health(0,0)



func update_fighter_image():
	for x in range(fighterList.size()):
		if get_fighter(x) != null:
			fighterRectList[x].set_image(get_fighter(x).image)
			fighterRectList[x].visible = true
		else:
			fighterRectList[x].set_image(null)
			#fighterRectList[x].visible = false


#Die Funtionen auf die einzelnen Kämpfer:
func kill(unit):
	remove_fighter(unit)


func refresh(fighter):
	get_fighter(fighter).health = get_fighter(fighter).maxHealth


#Other use full functions:

func customComparison(a,b):
	if typeof(a) != typeof(b):
		return typeof(a) > typeof(b)
	else:
		return get_fighter(a).momentum > get_fighter(b).momentum


func find_CharacterContainer() -> Array:
	var fighterRectList = []
	fighterRectList.append($BigBox/T/FR/V/C)
	fighterRectList.append($BigBox/T/FR/V2/C2)
	fighterRectList.append($BigBox/T/FR/V3/C3)
	fighterRectList.append($BigBox/T/FR/C4)
	
	fighterRectList.append($BigBox/T2/FR/V3/C5)
	fighterRectList.append($BigBox/T2/FR/V/C6)
	fighterRectList.append($BigBox/T2/FR/V2/C7)
	fighterRectList.append($BigBox/T2/FR/C8)
	return fighterRectList



func set_up_fighter_list() -> Array:
	var fighterListt = []
	for i in range(teamSize*2):
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
			var targets = select_targets(get_fighter(activeFighter).moves[num])
			timeLine.set_order(set_time_line(initative), get_fighter(activeFighter).moves[num],get_fighter(activeFighter).icon)
			for i in targets:
				fighterRectList[i].set_selection(true)
		else:
			button_time_start = -1
	


func _on_AttackButtons_attackUP(num):
	if(targetChooseMode == false):
		for i in fighterRectList:
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
