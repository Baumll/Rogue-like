extends Control

signal start_pressed
signal load_pressed
onready var button = $MarginContainer/Button2
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var save_game = File.new()
	if !save_game.file_exists(GlobalFunktions.save_file):
		button.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	emit_signal("start_pressed")


func _on_Button2_button_down():
	emit_signal("load_pressed")
