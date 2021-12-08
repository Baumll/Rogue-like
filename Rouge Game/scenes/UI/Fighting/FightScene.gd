extends Control

signal loadAttacks(moves)
signal endFight(team)
signal playSound(sound)


onready var timeLine = $FighterTimeLine

var rng = RandomNumberGenerator.new()

var fighterList = Array()  #Ein 2D array mit der Liste der Kämpfer geilt in die Teams
var fighterRectList = Array()
var fighterHealthBarList = Array()
var fighterStatusBarList = Array()
var fighterSelectList = Array()
var fighterAnimationList = Array()
var activeFighter
var activeMove

var isAnimationPlaying = false #Ob gerade eine Animation spielt Achtunr geht nur wenn alle animationen gleichlang sind

var initative = []

var moves = [] # Eine Lsiter der Moves die der aktive champion nutzen kann
var fighterTargetList = [] #Die Kämpfer die gerade anvisiert werden
var targetChooseMode = false

export(bool) var pacifism = true
export(int) var teamSize = 3

# Called when the node enters the scene tree for the first time.
func setup_fight():
	#Set up the fighter List
	fighterList = set_up_fighter_list()
	initative = []
	fighterRectList = find_texture_reck()
	fighterHealthBarList = find_health_bar()
	fighterStatusBarList = find_status_bar()
	fighterSelectList = find_select_bar()
	fighterAnimationList = find_animations()
	for x in fighterHealthBarList:
			x.set_bar(0)


func start_fight():
	rng.randomize()
	for x in initative:
		get_fighter(x).momentum = 0
		update_health(x)
	next_round()
	set_active_fighter(initative[0])


func end_fight(team):
	pacifism = true
	initative = []
	for x in fighterRectList:
		x = null
	for x in fighterHealthBarList:
		x.set_bar(0)
	pacifism = true
	emit_signal("endFight", team)
	

func next_round():
	print("next Round")
	for x in initative:
		get_fighter(x).momentum += get_fighter(x).speed
	initative.sort_custom(self, "customComparison")
	if(get_fighter(initative[0]).momentum <= 0):
		next_round()

#0 = Enemy 1= fiendly
func add_fighter(fighterObj, team):
	for x in range(team*teamSize, teamSize+team*teamSize):
		if(get_fighter(x) == null):
			fighterList[x] = fighterObj
			initative.append(x)
			initative.sort_custom(self, "customComparison")
			update_fighter_image()
			update_health(x)
			timeLine.set_order( set_time_line(initative))
			return


func remove_fighter(num):
	fighterList[num] = null
	initative = []
	for x in range(fighterList.size()):
		if get_fighter(x) != null:
			initative.append(x)
	initative.sort_custom(self, "customComparison")
	update_fighter_image()
	update_health(num)
	if get_fighter(0) == null && get_fighter(1) == null && get_fighter(2) == null:
		#Lose
		end_fight(1)
		return
	if get_fighter(3) == null && get_fighter(4) == null && get_fighter(5) == null:
		#Win
		end_fight(0)
		return


func set_active_fighter(num):
	for i in fighterSelectList:
		i.visible = false
	if(activeFighter != null):
		fighterRectList[activeFighter].hover = false
	print("Momentum: " + String(get_fighter(num).momentum))
	activeFighter = num
	get_fighter(num).iterate_status()
	fighterRectList[num].hover = true
	if num < 3: #Wenn ein gegner dran ist nutz eine zufällige attacke
		num = rng.randi_range(0,get_fighter(activeFighter).moves.size()-1)
		while get_fighter(activeFighter).moves[num] == null:
			num = rng.randi_range(0,get_fighter(activeFighter).moves.size()-1)
		make_move(get_fighter(activeFighter).moves[num])
	else: #Wenn ein Verbündeter dran ist
		emit_signal("loadAttacks", get_fighter(activeFighter).moves)
	fighterStatusBarList[activeFighter].load_list(get_fighter(activeFighter).statusList)
	fighterSelectList[activeFighter].visible = true

func get_fighter(num) -> Resource:
	if( fighterList[num] != null):
		return fighterList[num]
	else:
		return null

#Gibt das Animatet sprite raus mit der nummer
func get_animation_player(num) -> AnimatedSprite:
	if(num < fighterAnimationList.size()):
		return fighterAnimationList[num]
	
	return null


#der move wird aufgeführt  Animation kommt noch dazu
func make_move(move):
	targetChooseMode = false
	if pacifism == false: 
		if(get_fighter(activeFighter).momentum >= 0):
			select_targets(move)
			if targetChooseMode == false:
				play_move_sound(move)
				for x in fighterTargetList:
					if get_fighter(x) != null: 
						use_move_on_fighter(x, move)
						play_move_animation(x, move)
				for x in fighterTargetList:
					if get_fighter(x) != null: 
						yield( get_animation_player(x), "animation_finished" )
				get_fighter(activeFighter).momentum -= move.cost
				initative.sort_custom(self, "customComparison")
				if initative.size() > 0:
					if get_fighter(initative[0]).momentum > 0:
						set_active_fighter(initative[0])
						return
					
					next_round()
					set_active_fighter(initative[0])
					timeLine.set_order( set_time_line(initative))
			else:
				for i in fighterTargetList:
					fighterSelectList[i].visible = true

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
			if( activeFighter < 3):
				tempTargetList.append(3)
				tempTargetList.append(4)
				tempTargetList.append(5)
			else:
				tempTargetList.append(0)
				tempTargetList.append(1)
				tempTargetList.append(2)
			targetChooseMode = true
			activeMove = move
		move.target_kinds.inFront:
			tempTargetList.append(fmod(activeFighter+3, 6))
		move.target_kinds.adjacentEnemy:
			if(activeFighter == 1):
				tempTargetList.append(3)
				tempTargetList.append(4)
				tempTargetList.append(5)
			elif(activeFighter == 4):
				tempTargetList.append(0)
				tempTargetList.append(1)
				tempTargetList.append(2)
			elif activeFighter == 0:
				tempTargetList.append(3)
				tempTargetList.append(4)
			elif activeFighter == 2:
				tempTargetList.append(5)
				tempTargetList.append(4)
			elif activeFighter == 3:
				tempTargetList.append(0)
				tempTargetList.append(1)
			elif activeFighter == 5:
				tempTargetList.append(1)
				tempTargetList.append(2)
		
		move.target_kinds.allEnemy:
			if( activeFighter < 3):
				tempTargetList.append(3)
				tempTargetList.append(4)
				tempTargetList.append(5)
			else:
				tempTargetList.append(0)
				tempTargetList.append(1)
				tempTargetList.append(2)
				
		move.target_kinds.me:
			tempTargetList.append(activeFighter)
			
		move.target_kinds.allTeamOther:
			match activeFighter:
				0:
					tempTargetList.append(1)
					tempTargetList.append(2)
				1:
					tempTargetList.append(0)
					tempTargetList.append(2)
				2:
					tempTargetList.append(1)
					tempTargetList.append(0)
				3:
					tempTargetList.append(4)
					tempTargetList.append(5)
				4:
					tempTargetList.append(3)
					tempTargetList.append(5)
				5:
					tempTargetList.append(4)
					tempTargetList.append(3)
		move.target_kinds.allTeam:
			if activeFighter < 3:
				tempTargetList.append(0)
				tempTargetList.append(1)
				tempTargetList.append(2)
			else:
				tempTargetList.append(3)
				tempTargetList.append(4)
				tempTargetList.append(5)
	fighterTargetList = []
	for x in tempTargetList:
		if get_fighter(x) != null:
			fighterTargetList.append(x)
	
	
#die moves werden auf die Ziele angewand
func use_move_on_fighter(fighter, move):
	for x in range(move.moves.size()):
		
		match move.moves[x]:
			move.move_kinds.strike:
				strike(fighter, move.value[x])
			move.move_kinds.buff:
				buff(fighter, move.value[x])
			move.move_kinds.heal:
				heal(fighter, move.value[x])

#Spielt die Animation bei kämpfer num von move ab
func play_move_animation(num, move):
	if (move.animation != null):
		get_animation_player(num).set_visible(true);
		get_animation_player(num).play()
		get_animation_player(num).frame = 0

func play_move_sound(move):
	emit_signal("playSound", move.sound)

#die Moves
func strike(fighter, num):
	get_dmg(fighter,num)
	pass
	
func buff(fighter, status):
	status.turns = status.maxTurns
	print(get_fighter(fighter))
	fighterStatusBarList[fighter].load_list(get_fighter(fighter).statusList)
	update_health(fighter)
	get_fighter(fighter).append_status(status)


func heal(fighter, num):
	print("heal")
	get_heal(fighter, num)
	update_health(fighter)
	pass


func update_health(num):
	if(get_fighter(num) != null):
		fighterHealthBarList[num].set_bar(max(0,(float(get_fighter(num).health) / float(get_fighter(num).maxHealth))* 100))
	else:
		fighterHealthBarList[num].set_bar(0)



func update_fighter_image():
	for x in range(fighterList.size()):
		if get_fighter(x) != null:
			fighterRectList[x].texture = get_fighter(x).image
		else:
			fighterRectList[x].texture  = null
	


#Die Funtionen auf die einzelnen Kämpfer:
func kill(unit):
	remove_fighter(unit)


func refresh(fighter):
	get_fighter(fighter).health = get_fighter(fighter).maxHealth


func get_dmg(fighter, amount):
	get_fighter(fighter).health -= (amount - amount*(get_fighter(fighter).defence/10))
	if get_fighter(fighter).health <= 0:
		kill(fighter)
	update_health(fighter)


func get_heal(unit, amount):
	get_fighter(unit).health += amount
	if get_fighter(unit).health > get_fighter(unit).maxHealth:
		get_fighter(unit).health = get_fighter(unit).maxHealth
	update_health(unit)




#Other use full functions:

func customComparison(a,b):
	if typeof(a) != typeof(b):
		return typeof(a) > typeof(b)
	else:
		return get_fighter(a).momentum > get_fighter(b).momentum


func find_texture_reck() -> Array:
	var fighterRectList = []
	fighterRectList.append($BigBox/Teams/TopTeam/FightersRoster/MarginContainer/HPImage/CenterContainer/TextureRect)
	fighterRectList.append($BigBox/Teams/TopTeam/FightersRoster/MarginContainer2/HPImage2/CenterContainer/TextureRect)
	fighterRectList.append($BigBox/Teams/TopTeam/FightersRoster/MarginContainer3/HPImage3/CenterContainer/TextureRect)
	
	fighterRectList.append($BigBox/Teams/TopTeam2/FightersRoster/MarginContainer/HPImage/CenterContainer/TextureRect)
	fighterRectList.append($BigBox/Teams/TopTeam2/FightersRoster/MarginContainer2/HPImage2/CenterContainer/TextureRect)
	fighterRectList.append($BigBox/Teams/TopTeam2/FightersRoster/MarginContainer3/HPImage3/CenterContainer/TextureRect)
	return fighterRectList

func find_animations() -> Array:
	var AnimationRectList = []
	AnimationRectList.append($BigBox/Teams/TopTeam/FightersRoster/MarginContainer/HPImage/CenterContainer/TextureRect/AnimatedSprite)
	AnimationRectList.append($BigBox/Teams/TopTeam/FightersRoster/MarginContainer2/HPImage2/CenterContainer/TextureRect/AnimatedSprite)
	AnimationRectList.append($BigBox/Teams/TopTeam/FightersRoster/MarginContainer3/HPImage3/CenterContainer/TextureRect/AnimatedSprite)
	
	AnimationRectList.append($BigBox/Teams/TopTeam2/FightersRoster/MarginContainer/HPImage/CenterContainer/TextureRect/AnimatedSprite)
	AnimationRectList.append($BigBox/Teams/TopTeam2/FightersRoster/MarginContainer2/HPImage2/CenterContainer/TextureRect/AnimatedSprite)
	AnimationRectList.append($BigBox/Teams/TopTeam2/FightersRoster/MarginContainer3/HPImage3/CenterContainer/TextureRect/AnimatedSprite)
	return AnimationRectList

func find_health_bar() -> Array:
	var healthBarList = []
	healthBarList.append($BigBox/Teams/TopTeam/FightersRoster/MarginContainer/HPImage/HealthBar)
	healthBarList.append($BigBox/Teams/TopTeam/FightersRoster/MarginContainer2/HPImage2/HealthBar)
	healthBarList.append($BigBox/Teams/TopTeam/FightersRoster/MarginContainer3/HPImage3/HealthBar)
	
	healthBarList.append($BigBox/Teams/TopTeam2/FightersRoster/MarginContainer/HPImage/HealthBar)
	healthBarList.append($BigBox/Teams/TopTeam2/FightersRoster/MarginContainer2/HPImage2/HealthBar)
	healthBarList.append($BigBox/Teams/TopTeam2/FightersRoster/MarginContainer3/HPImage3/HealthBar)
	return healthBarList
	
	
func find_status_bar() -> Array:
	var statusBarList = []
	statusBarList.append($BigBox/Teams/TopTeam/FightersRoster/MarginContainer/HPImage/StatusBar)
	statusBarList.append($BigBox/Teams/TopTeam/FightersRoster/MarginContainer2/HPImage2/StatusBar)
	statusBarList.append($BigBox/Teams/TopTeam/FightersRoster/MarginContainer3/HPImage3/StatusBar)
	
	statusBarList.append($BigBox/Teams/TopTeam2/FightersRoster/MarginContainer/HPImage/StatusBar)
	statusBarList.append($BigBox/Teams/TopTeam2/FightersRoster/MarginContainer2/HPImage2/StatusBar)
	statusBarList.append($BigBox/Teams/TopTeam2/FightersRoster/MarginContainer3/HPImage3/StatusBar)
	return statusBarList
	
func find_select_bar() -> Array:
	var selectbarList = []
	selectbarList.append($BigBox/Teams/TopTeam/FightersRoster/MarginContainer/HPImage/TextureRect)
	selectbarList.append($BigBox/Teams/TopTeam/FightersRoster/MarginContainer2/HPImage2/TextureRect2)
	selectbarList.append($BigBox/Teams/TopTeam/FightersRoster/MarginContainer3/HPImage3/TextureRect3)
	
	selectbarList.append($BigBox/Teams/TopTeam2/FightersRoster/MarginContainer/HPImage/TextureRect4)
	selectbarList.append($BigBox/Teams/TopTeam2/FightersRoster/MarginContainer2/HPImage2/TextureRect5)
	selectbarList.append($BigBox/Teams/TopTeam2/FightersRoster/MarginContainer3/HPImage3/TextureRect6)
	return selectbarList

func set_up_fighter_list() -> Array:
	var fighterListt = []
	for i in range(teamSize*2):
		fighterListt.append(null)
	return fighterListt



func _on_BigBox_down(num):
	pass # Replace with function body.


func _on_BigBox_up(num):
	if targetChooseMode:
		play_move_sound(activeMove)
		for i in fighterTargetList:
			if i == num:
				if get_fighter(i) != null: 
					use_move_on_fighter(num, activeMove)
					play_move_animation(num, activeMove)
					targetChooseMode = false
				get_fighter(activeFighter).momentum -= activeMove.cost
				initative.sort_custom(self, "customComparison")
				if initative.size() > 0:
					if get_fighter(initative[0]).momentum > 0:
						set_active_fighter(initative[0])
						return
					next_round()
					set_active_fighter(initative[0])
					timeLine.set_order( set_time_line(initative))
					


func _on_AttackButtons_attack(num):
	if num != -1:
		if !pacifism: 
			if(get_fighter(activeFighter).moves.size() > num):
				make_move(get_fighter(activeFighter).moves[num])





func _on_AnimatedSprite_animation_finished():
	pass # Replace with function body.
