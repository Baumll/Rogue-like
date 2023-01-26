extends Node2D

signal selected(list)

onready var grid = $GridContainer 
var button_with_image = preload("res://scenes/UI/ui_under/ButtonWithImage.tscn")
onready var blur = $Blur
var return_list = []res://scenes/Rooms/mentor/character_select.gd

# Called when the node enters the scene tree for the first time.
func _ready():
	blur.material.set_shader_param("blur", 4.0)

func load_moves(moves):
	return_list = moves
	for i in moves:
		var button = button_with_image.instance()
		grid.add_child(button)
		button.set_image(i.image)
		button.rect_min_size = Vector2(grid.rect_size.x/2,grid.rect_size.y/2)
		button.connect("buttonNum",self,"select")

func load_heros(heros):
	return_list = heros
	for i in heros:
		var button = button_with_image.instance()
		grid.add_child(button)
		button.set_image(i.icon)
		button.rect_min_size = Vector2(grid.rect_size.x/2,grid.rect_size.y/2)
		button.connect("buttonNum",self,"select")


func select(num):
	emit_signal("selected",return_list[num])


func _on_Button_button_up():
	emit_signal("hero_selected",null)
