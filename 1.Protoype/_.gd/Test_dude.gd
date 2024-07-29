extends CharacterBody3D

const MASS = 1
const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var item_picked_up = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


# """""""""""""""""""""""""""""""""
# Tutorial for moving objects, 
# gets a bit glitchy when jumping on objects,
# may need to be tweaked
# """""""""""""""""""""""""""""""""
func _push_rigidbodies():
	for i in get_slide_collision_count():
		var col = get_slide_collision(i)
		if col.get_collider() is RigidBody3D:
			var dir = -col.get_normal()
			var velocity_diff_in_dir = self.velocity.dot(dir) - col.get_collider().linear_velocity.dot(dir)
			velocity_diff_in_dir = max(0., velocity_diff_in_dir)
			var mass_ratio = min(1., MASS / col.get_collider().mass)
			var push_force = mass_ratio * 5
			col.get_collider().apply_impulse(dir * velocity_diff_in_dir * push_force,\
			col.get_position() - col.get_collider().global_position)


# """""""""""""""""""""""""""""""""
# Gets closest item that is inside
# the area 3d of hardpoint
# """""""""""""""""""""""""""""""""
func _get_pick_up_item():
	var check_area = get_node("/root/Main/Entities/CharacterBody3D/Node3D/Area3D")
	if check_area.has_overlapping_bodies() == true:
		var objects = check_area.get_overlapping_bodies()
		var list = [1, 2, 4, 3]
		var closest_obj
		var shortest_Distance = -1
		for i in objects:
			if i is RigidBody3D:
				var distance = check_area.position.distance_to(i.position)
				if shortest_Distance == -1:
					shortest_Distance = distance
					closest_obj = i
				elif  distance < shortest_Distance:
					shortest_Distance = distance
					closest_obj = i
		return(closest_obj)


#func _turn_rotation():
	#var original = Basis.IDENTITY.z
	#var current = self.basis.z
	#var angle = acos(original.dot(current) * (original.length() * current.length()))
	#print("________________________________________________________________________")
	#print(angle)
	#print(velocity)
	##velocity = velocity.rotated(velocity.normalized(), angle)
	#velocity = velocity.rotated(Vector3(1, 0, 1).normalized(), angle)
	#print(velocity)
	#print(Input.get_mouse_mode())
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta


	# Handle jump.
	if Input.is_action_just_pressed("ui_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (Basis.IDENTITY * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)


	# """""""""""""""""""""""""
	# Item pick up and drop,
	# needs cleaning up
	# """""""""""""""""""""""""
	if Input.is_action_just_pressed("Pick_up"):
		if item_picked_up == false:
			var obj = _get_pick_up_item()
			if obj != null:
				item_picked_up = true
				obj.get_child(0).disabled = true
				obj.freeze = true
				obj.position = Vector3(0, 0, 0)
				get_node("/root/Main/Level's/Items").remove_child(obj)
				get_node("/root/Main/Entities/CharacterBody3D/Node3D").add_child(obj)
		else:
			var obj = get_node("/root/Main/Entities/CharacterBody3D/Node3D").get_child(2)
			var pos = obj.global_position
			item_picked_up = false
			obj.get_child(0).disabled = false
			obj.freeze = false
			obj.position = pos
			get_node("/root/Main/Entities/CharacterBody3D/Node3D").remove_child(obj)
			get_node("/root/Main/Level's/Items").add_child(obj)


	#var new_char_direction = Vector3(velocity.x, 0, velocity.z)
	#var old_char_direction = Vector3(cos(self.rotation.y), 0, sin(self.rotation.y))
	#var dot_stuff = new_char_direction.dot(old_char_direction)/ \
	#new_char_direction.length() * old_char_direction.length()
	#var angle_diff = acos((int(dot_stuff)) % int(90))
	#self.rotation.y = lerp_angle(self.rotation.y, self.rotation.y + angle_diff, 0.2)
	#"""""""""""""""""""""""""""""
	# broken turning stuffSS
	#"""""""""""""""""""""""""""""


	#if velocity.x != 0 or velocity.z != 0:
		#
		#var hori_vel = Vector3(velocity.x, 0, velocity.z)
		#print("________________________")
		#self.basis.z = hori_vel.normalized()
		#self.basis.x = self.basis.z.rotated(Vector3(1, 0, 1).normalized(), PI/2)
		#self.look_at(transform.origin + velocity, Vector3.UP)	
		#_turn_rotation()
		

	_push_rigidbodies()
	move_and_slide()
