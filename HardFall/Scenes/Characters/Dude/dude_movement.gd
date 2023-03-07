extends RigidBody3D

@export var speed = 60
@export var small_jump_acc = 60
@export var gravitational_acc = -20
@export var mouse_sensitivity = 0.05

@onready var camera = $Body/Pivot/Camera3D
@onready var body = $Body
@onready var big_feet = $Body/Collsion/BigFeet
@onready var small_feet = $Body/Collsion/SmallFeet
@onready var pivot = $Body/Pivot

var can_jump = true

var direction_of_movement = Vector3()
var input_movement_vector = Vector3()
var shifting = false
var final_acc = Vector3()
var x_acc = 0
var z_acc = 0

var rewind_status = 0; # 0 = nothing | 1 = recording | 2 = rewinding | 3 = playing
var input_record = []; # delta | movement_forward | movement_backward | movement_left | movement_right | movement_shift | movement_jump | ?mouse_left?


func calculate_ground_acc(cur_speed, desired_speed):
	return -8*cur_speed + desired_speed


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta):
	process_input(delta)
	process_movement(delta)


func process_input(_delta):	
	var cam_xform = camera.get_global_transform()
	
	direction_of_movement = Vector3()
	input_movement_vector = Vector3()
	shifting = false
	
	if Input.is_action_pressed("movement_forward"):
		input_movement_vector.z += 1
	if Input.is_action_pressed("movement_backward"):
		input_movement_vector.z -= 1
	if Input.is_action_pressed("movement_left"):
		input_movement_vector.x -= 1
	if Input.is_action_pressed("movement_right"):
		input_movement_vector.x += 1
	
	if Input.is_action_pressed("movement_shift"):
		shifting = true
	
	input_movement_vector = input_movement_vector.normalized()

	# Basis vectors are already normalized.
	direction_of_movement += -cam_xform.basis.z * input_movement_vector.z
	direction_of_movement += cam_xform.basis.x * input_movement_vector.x
	direction_of_movement.y = 0 # IMPORTAN so it doesn't move slower if we look down
	
	direction_of_movement = direction_of_movement.normalized() # important to do this before y
	
	if Input.is_action_pressed("movement_jump"):
		input_movement_vector.y += 1
	
	direction_of_movement.y = input_movement_vector.y
	
	# Capturing/Freeing the cursor
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# ----------------------------------


func process_movement(delta):
	# shifting proccesing
	if shifting:
		$CollisionShape3D.scale.y = 0.5
		$Body/MeshInstance3D.scale.y = 0.5
		
		$Body/Collsion.position.y = 0.5
		$Body/Pivot.position.y = -0.25
		
		sleeping = false
	elif $CollisionShape3D.scale.y != 0:
		$CollisionShape3D.scale.y = 1
		$Body/MeshInstance3D.scale.y = 1
		
		$Body/Collsion.position.y = 0
		$Body/Pivot.position.y = 0.5
	
	# movement already normalized
	final_acc = Vector3()
	
	# make acceleration negative only if small_feet are colldiing
	if small_feet.is_colliding():
		var _speed = speed
		if shifting: _speed = speed/4.0
		x_acc = calculate_ground_acc(linear_velocity.x, _speed * direction_of_movement.x)
		z_acc = calculate_ground_acc(linear_velocity.z, _speed * direction_of_movement.z)
	else:
		x_acc = 0.2 * speed * direction_of_movement.x
		z_acc = 0.2 * speed * direction_of_movement.z
	
	final_acc.x += x_acc * delta
	final_acc.z += z_acc * delta
	
	
	
	#jumping
	if can_jump:
		final_acc.y += direction_of_movement.y * small_jump_acc * delta
		if small_feet.is_colliding():
			final_acc.y += direction_of_movement.y * 8 * small_jump_acc * delta # again if small feet
	
	if small_feet.is_colliding(): can_jump = true
	
	if !big_feet.is_colliding():
		can_jump = false
	
	# gravity
	final_acc.y += gravitational_acc * delta
	
	linear_velocity += final_acc
	
	if small_feet.is_colliding() and linear_velocity.length() < 0.8: linear_velocity.y = 0 # a shitty fix, but it works
	
	# print(final_acc.y)


func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		pivot.rotate_x(deg_to_rad(event.relative.y * mouse_sensitivity * -1))
		body.rotate_y(deg_to_rad(event.relative.x * mouse_sensitivity * -1))

		var camera_rot = pivot.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -89, 89)
		pivot.rotation_degrees = camera_rot
