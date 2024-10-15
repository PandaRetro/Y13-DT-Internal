extends CharacterBody3D

var tween
var average_points
var bases = []
var cur_targ = []
var new_targ = []
var grounded = []

const N0_LEGS = 8
const SPEED = 5.0


func _ready():
	#bases = $Points/Bases.get_children()
	for i in range(N0_LEGS):
		var arm = $Arms.get_children()[i]
		bases.append(arm.get_child(1))
		cur_targ.append(arm.get_child(2))
		cur_targ[i].position = bases[i].global_position
		new_targ.append(cur_targ[i].position)
		grounded.append(true)


func _physics_process(delta):

	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	#main loop for all leg movement
	average_points = 0
	for i in range(len(bases)): 
		average_points += cur_targ[i].position.y
		var diff = velocity
		diff.y = 0

		#adjust base positions
		if _ray_cast(bases[i].global_position) != {}: 
			bases[i].global_position = _ray_cast(bases[i].global_position)["position"]

		#checks for movement, and animation
		if (bases[i].global_position - cur_targ[i].position).length() > (diff.length() * 0.25) and \
		grounded[i - 1] == true and \
		grounded[(i + 1) % len(cur_targ)] == true and \
		grounded[i] == true:
			grounded[i] = false
			new_targ[i] = (bases[i].global_position + (diff.normalized() * diff.length() * 0.25))

			#adjust target positions
			if _ray_cast(new_targ[i]) != {}:
				new_targ[i] = _ray_cast(new_targ[i])["position"]

			var intermediate = bases[i].global_position
			intermediate.y += ((cur_targ[i].position - new_targ[i]).length()) / 4

			#animate
			tween = create_tween()
			tween.tween_property(cur_targ[i], "position", intermediate, 0.05)
			tween.tween_property(cur_targ[i], "position", new_targ[i], 0.05)
			tween.tween_callback(func(): grounded[i] = true)

	#rotation and position for body
	self.position.y = lerp(self.position.y, (average_points/8) + 1.25, 0.3)
	if velocity.length()> 0.1 :
		self.rotation.y = lerp_angle(self.rotation.y, atan2(velocity.x, velocity.z), 0.05)

	move_and_slide()


func _ray_cast(point):
	var params = PhysicsRayQueryParameters3D.new()
	params.from = point + Vector3(0, 2, 0)
	params.to = point + Vector3(0, -3, 0)
	var result = get_world_3d().direct_space_state.intersect_ray(params)
	return(result)

