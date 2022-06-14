extends TextureRect


export(bool) var hover = false
var pos = 0
var speed = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#
func sethover(hov):
	hover = hov

func _process(delta):
	if hover == true:
		margin_top = sin(pos)*3
		pos = fmod(pos+(1 * speed), 360)
