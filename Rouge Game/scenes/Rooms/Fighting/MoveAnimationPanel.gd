extends Control

signal animation_finished
signal playSound(sound)
signal shake

var screen_width = 1080
var screen_height = 960
var image_height = 440
var image_width = 280
var team_size = 4
var timeWait = 0.5

var selfTarget = false

var targets = 0

export(Resource) var animations
var floaty_text_scene = preload("res://scenes/Rooms/Fighting/Floating_Text.tscn")

onready var targetAnimList = [$AnimatedSprite,$AnimatedSprite2, $AnimatedSprite3,$AnimatedSprite4,$AnimatedSprite5]
onready var targetTexList = [$TextureRect,$TextureRect2,$TextureRect3,$TextureRect4,$TextureRect5]

#Farben für die DMG zahlen:
var physicColor = Color('33040b')
var magicColor = Color('33BBCC')
var healColor = Color('42ce00')


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func load_images(args, team):
	selfTarget = false
	targets = args.size()
	for i in range(0, args.size()):
		targetTexList[i].texture = args[i]
	#Schauen ob der Move sich selber betrifft
	var sub_array = args.slice(1, args.size()-1)
	if(sub_array.has(args[0])):
		if(team == 0):
			for i in range(0, args.size()):
				targetTexList[i].flip_h = false
		else:
			for i in range(0, args.size()):
				targetTexList[i].flip_h = true
		selfTarget = true
		match(args.size()-1):
			1:
				if(team == 1):
					targetTexList[0].flip_h = true
				targetTexList[0].visible = true
				targetTexList[0].rect_size =  Vector2(image_width,image_height)
				targetTexList[0].rect_position = Vector2(screen_width/2 - image_width/2,screen_height/2 - image_height/2)
				targetAnimList[0].visible = true
				targetAnimList[0].position = Vector2(screen_width/2 - image_width/2 + image_width/2,260 + image_height/2)
			2:
				for i in range(0,2):
					if(team == 1):
						targetTexList[i].flip_h = true
					targetTexList[i].visible = true
					targetTexList[i].rect_size =  Vector2(image_width,image_height)
					targetTexList[i].rect_position = Vector2(200 + (image_width + 80)*i,screen_height/2 - image_height/2)
					targetAnimList[i].visible = true
					targetAnimList[i].position = Vector2(200 + (image_width + 80)*i + image_width/2,260 + image_height/2)
			3:
				for i in range(0,3):
					if(team == 1):
						targetTexList[i].flip_h = true
					targetTexList[i].visible = true
					targetTexList[i].rect_size =  Vector2(image_width,image_height)
					targetTexList[i].rect_position = Vector2(250 + (image_width/2 + 10)*i, 40 + (1+fmod(i,2)*-1)*image_height)
					targetAnimList[i].visible = true
					targetAnimList[i].position = Vector2(250 + (image_width/2 + 10)*i + image_width/2, 40 + (1+fmod(i,2)*-1)*image_height + image_height/2)
			4:
				for i in range(0,2):
					for j in range (0,2):
						if(team == 1):
							targetTexList[i+j*2].flip_h = true
						targetTexList[i+j*2].visible = true
						targetTexList[i+j*2].rect_size =  Vector2(image_width,image_height)
						targetTexList[i+j*2].rect_position = Vector2(250 + (image_width+20)*fmod(i,2), 40 + (1+fmod(j,2)*-1)*image_height)
						targetAnimList[i+j*2].visible = true
						targetAnimList[i+j*2].position = Vector2(250 + (image_width+20)*fmod(i,2) + image_width/2, 40 + (1+fmod(j,2)*-1)*image_height + image_height/2)
	else:
		#Wenn die Person nicht sich selber castet
		match(args.size()-1):
			1:
				if(team == 1):
					for i in range(0,2):
						if( i == 1):
							targetTexList[i].flip_h = true
							targetAnimList[i].visible = true
						else:
							targetTexList[i].flip_h = false
						targetTexList[i].visible = true
						targetTexList[i].rect_size =  Vector2(image_width,image_height)
						targetTexList[i].rect_position = Vector2(170 + (image_width + 180)*(i),screen_height/2 - image_height/2)
						targetAnimList[i].position = Vector2(170 + (image_width + 180)*(i) + image_width/2,260 + image_height/2)
				else:
					for i in range(0,2):
						if( i == 0):
							targetTexList[i].flip_h = true
						else:
							targetTexList[i].flip_h = false
							targetAnimList[i].visible = true
						targetTexList[i].visible = true
						targetTexList[i].rect_size =  Vector2(image_width,image_height)
						targetTexList[i].rect_position = Vector2(630 - (image_width + 180)*(i),screen_height/2 - image_height/2)
						targetAnimList[i].position = Vector2(630 - (image_width + 180)*(i) + image_width/2,260 + image_height/2)
			2:
				if(team == 1):
					targetTexList[0].flip_h = false
					targetTexList[0].visible = true
					targetTexList[0].rect_size =  Vector2(image_width,image_height)
					targetTexList[0].rect_position = Vector2(80,screen_height/2 - image_height/2)
					for i in range(1,3):
						targetTexList[i].flip_h = true
						targetTexList[i].visible = true
						targetTexList[i].rect_size =  Vector2(image_width,image_height)
						targetTexList[i].rect_position = Vector2(440 + (image_width + 20)*(i-1),screen_height/2 - image_height/2)
						targetAnimList[i].visible = true
						targetAnimList[i].position = Vector2(440 + (image_width + 20)*(i-1) + image_width/2,260 + image_height/2)
				else:
					targetTexList[0].flip_h = true
					targetTexList[0].visible = true
					targetTexList[0].rect_size =  Vector2(image_width,image_height)
					targetTexList[0].rect_position = Vector2(740,screen_height/2 - image_height/2)
					for i in range(1,3):
						targetTexList[i].flip_h = false
						targetTexList[i].visible = true
						targetTexList[i].rect_size =  Vector2(image_width,image_height)
						targetTexList[i].rect_position = Vector2(80 + (image_width + 20)*(i-1),screen_height/2 - image_height/2)
						targetAnimList[i].visible = true
						targetAnimList[i].position = Vector2(80 + (image_width + 20)*(i-1) + image_width/2,260 + image_height/2)
			3:
				if(team == 1):
					targetTexList[0].flip_h = false
					targetTexList[0].visible = true
					targetTexList[0].rect_size =  Vector2(image_width,image_height)
					targetTexList[0].rect_position = Vector2(80,260)
					for i in range(1,4):
						targetTexList[i].flip_h = true
						targetTexList[i].visible = true
						targetTexList[i].rect_size =  Vector2(image_width,image_height)
						targetTexList[i].rect_position = Vector2(440 + (image_width/2 + 10)*(i-1), 40 + (1+fmod((i-1),2)*-1)*image_height)
						targetAnimList[i].visible = true
						targetAnimList[i].position = Vector2(440 + (image_width/2 + 10)*(i-1) + image_width/2, 40 + (1+fmod((i-1),2)*-1)*image_height + image_height/2)
				else:
					targetTexList[0].flip_h = true
					targetTexList[0].visible = true
					targetTexList[0].rect_size =  Vector2(image_width,image_height)
					targetTexList[0].rect_position = Vector2(740,260)
					for i in range(1,4):
						targetTexList[i].flip_h = false
						targetTexList[i].visible = true
						targetTexList[i].rect_size =  Vector2(image_width,image_height)
						targetTexList[i].rect_position = Vector2(80 + (image_width/2 + 10)*(i-1), 40 + (1+fmod((i-1),2)*-1)*image_height)
						targetAnimList[i].visible = true
						targetAnimList[i].position = Vector2(80 + (image_width/2 + 10)*(i-1) + image_width/2, 40 + (1+fmod((i-1),2)*-1)*image_height + image_height/2)
			4:
				if(team == 1 ):
					targetTexList[0].flip_h = false
					targetTexList[0].visible = true
					targetTexList[0].rect_size =  Vector2(image_width,image_height)
					targetTexList[0].rect_position = Vector2(80,260)
					for i in range(0,2):
						for j in range (0,2):
							targetTexList[i+j*2+1].flip_h = true
							targetTexList[i+j*2+1].visible = true
							targetTexList[i+j*2+1].rect_size =  Vector2(image_width,image_height)
							targetTexList[i+j*2+1].rect_position = Vector2(440 + (image_width+20)*fmod(i,2), 40 + (1+fmod(j,2)*-1)*image_height)
							targetAnimList[i+j*2+1].visible = true
							targetAnimList[i+j*2+1].position = Vector2(440 + (image_width+20)*fmod(i,2) + image_width/2, 40 + (1+fmod(j,2)*-1)*image_height + image_height/2)
				else:
					targetTexList[0].flip_h = true
					targetTexList[0].visible = true
					targetTexList[0].rect_size =  Vector2(image_width,image_height)
					targetTexList[0].rect_position = Vector2(740,260)
					for i in range(0,2):
						for j in range (0,2):
							targetTexList[i+j*2+1].flip_h = false
							targetTexList[i+j*2+1].visible = true
							targetTexList[i+j*2+1].rect_size =  Vector2(image_width,image_height)
							targetTexList[i+j*2+1].rect_position = Vector2(80 + (image_width+20)*fmod(i,2), 40 + (1+fmod(j,2)*-1)*image_height)
							targetAnimList[i+j*2+1].visible = true
							targetAnimList[i+j*2+1].position = Vector2(80 + (image_width+20)*fmod(i,2) + image_width/2, 40 + (1+fmod(j,2)*-1)*image_height + image_height/2)

func play_Move(move, numbers):
	#number sind die Schaden/heal die die bekommen (auch Lebensraub)
	yield(get_tree().create_timer(timeWait), "timeout")
	play_move_sound(move)
	emit_signal("shake")
	for i in range(0, targets):
		if move != null:
			targetAnimList[i].frame = 0
			if "res://" in move.animation:
				targetAnimList[i].frames = load(move.animation)
				targetAnimList[i].play("Default")
			else:
				targetAnimList[i].play(move.animation)
		if i != 0:
			for j in range(0,numbers[i-1].size()):
				match j:
					0:
						#magic Schaden
						create_floaty_text(numbers[i-1][j],targetAnimList[i].position,physicColor)
					1:
						#Physischen Schaden
						create_floaty_text(numbers[i-1][j],targetAnimList[i].position,magicColor)
					2:
						#heal:
						create_floaty_text(numbers[i-1][j],targetAnimList[i].position,healColor)

func create_floaty_text(amount, position, color = Color('33040b') ):
	if(amount != null):
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

func create_floaty_text_fighter(fighter, type, amount):
	pass

func play_move_sound(move):
	emit_signal("playSound", move.sound)

func _on_AnimatedSprite_animation_finished():
	yield(get_tree().create_timer(timeWait), "timeout")
	emit_signal("animation_finished")
	for i in range(0, targetAnimList.size()):
		targetTexList[i].visible = false
		targetAnimList[i].visible = false

