extends Node3D

@export var reload_time = 0.4
@export var bat_impulse = 800

var bat_hit_ray
var bat_animation_player
var swinging_bat_timer = 0.0
var swinging

var direction_of_weapon = Vector3()

func _ready():
	bat_hit_ray = $HitRay
	bat_animation_player = $BatPivot/AnimationPlayer


func _process(delta):
	process_input(delta)
	process_actions(delta)


func process_input(delta):
	swinging = false
	if Input.is_action_pressed("mouse_left"):
		swinging = true


func process_actions(delta):
	var bat_xform = self.get_global_transform()
	# idk honestly
	direction_of_weapon = bat_xform.basis.x # RETARDATION ALERT
	direction_of_weapon = bat_xform.basis.y
	direction_of_weapon = bat_xform.basis.z
	direction_of_weapon = direction_of_weapon.normalized()
	
	if swinging_bat_timer < reload_time: # reload isn't over yet -> can't shoot
		swinging_bat_timer += delta
		# reload here VVV
		
	elif swinging: # can shoot & shooting
		# checking for rigid bodie & applying impulse
		if bat_hit_ray.is_colliding():
			print("hitting")
			
			var collider = bat_hit_ray.get_collider()
			
			if collider.get_class() == "RigidBody3D":
				print("rigid body")
				var global_collision_point = bat_hit_ray.get_collision_point()
				var global_collider_coords = collider.global_position
				
				var position_of_impulse =  global_collision_point - global_collider_coords  # RETARDATION ALERT
				
				collider.apply_impulse(position_of_impulse, 0.5 * bat_impulse * direction_of_weapon) # RETARDATION ALERT
				collider.apply_central_impulse(bat_impulse * (-direction_of_weapon)) # RETARDATION ALERT
			
			if collider.has_meta("type") and collider.get_meta("type") == "button":
				print("button")
				collider.pressed = true
			print(collider)
		
		# startting the animation of reloading/shooting
		bat_animation_player.play("swing")
		
		# starting the timer for reloading
		swinging_bat_timer = 0
		swinging = false
