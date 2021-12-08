extends Node

export(int) var InvWidth = 3
export(int) var InvHeight = 3
export(int) var merchantSize = 3
export(int) var equipSize = 2

export(Resource) var merchantSlots 
export(Resource) var invSlots
export(Resource) var equipSlots

var active = false
var selling = false


var invList = []
var sellList = [] 


# Called when the node enters the scene tree for the first time.
func _ready():
	setup_inventory()

func _process(delta):
	if active:
		if Input.is_action_just_pressed("ui_mouse_left"):
			if get_global_mouse_position() <= invSlots.rect_golobal_position:
				pass

func drag():
	if selling == true:
		pass
	
func drop():
	pass

func load_equip():
	pass

func remove_equip():
	pass

func add_equip():
	pass
	
func buy():
	pass

func sell():
	pass
	
	
func setup_inventory():
	invList = []
	for x in range(InvWidth*InvHeight):
		invList.append(null)

func setup_merchant():
	sellList = []
	for x in range(merchantSize):
		sellList.append(null)
