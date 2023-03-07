extends Node3D

@export var selected_weapon = 0
var weapons_n = 2
@onready var weapons = [$Bat, $FlashLight]


func _process(delta):
	process_input(delta)


func process_input(delta):
	if Input.is_action_pressed("key_1"):
		selected_weapon = 0
	if Input.is_action_pressed("key_2"):
		selected_weapon = 1
	if Input.is_action_pressed("key_3"):
		selected_weapon = 2
	
	select_weapon()


func select_weapon():
	for i in weapons_n:
		weapons[i]. set_process(false)
		if selected_weapon == i:
			weapons[i].set_process(true)
			weapons[i].show()
		else:
			weapons[i].set_process(false)
			weapons[i].hide()
