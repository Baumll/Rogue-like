extends Control


signal pressed
signal pressed_up
signal pressed_down
signal animation_finished

onready var tex = $HPImage/CenterContainer/TextureRect
onready var selection_sign = $SelectionSign
onready var HP_bar = $HPImage/HealthBar
onready var status_bar = $HPImage/StatusBar
onready var animator = $HPImage/CenterContainer/TextureRect/AnimatedSprite

export(bool) var flip = false
# Called when the node enters the scene tree for the first time.
func _ready():
	set_flip(flip)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_hover(hov):
	tex.sethover(hov)

func set_flip(flp):
	tex.flip_h = flp

func set_image(image):
	tex.texture = image


func set_selection(select):
	if select:
		selection_sign.visible = true
	else:
		selection_sign.visible = false

func set_health(maximal, amount):
	HP_bar.set_bar(maximal, amount)

func set_status_bar(list):
	status_bar.load_list(list)

func play_animation(animation):
	visible = true
	animator.frame = 0
	animator.play(animation)

func _on_Button_pressed():
	emit_signal("pressed")

func _on_AnimatedSprite_animation_finished():
	emit_signal("animation_finished")


func _on_Button_button_up():
	emit_signal("pressed_up")


func _on_Button_button_down():
	emit_signal("pressed_down")
