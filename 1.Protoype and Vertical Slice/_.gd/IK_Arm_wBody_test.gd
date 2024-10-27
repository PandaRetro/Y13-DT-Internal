extends CharacterBody3D

var base = []
var cur_targ = []
var new_targ = []
var tween
var curve
var grounded = []
var N0_points
var average_points
var gravity = 0 #ProjectSettings.get_setting("physics/3d/default_gravity")


const SPEED = 5.0
const JUMP_VELOCITY = 4.5



func _ready():
	base = $Points/Base.get_children()
	N0_points = len(base)
	cur_targ = $Points/Targets.get_children()
	for i in range(N0_points):
		cur_targ[i].position = to_global(base[i].position)
		new_targ.append(cur_targ[i].position)
		grounded.append(true)


func _physics_process(delta):
	
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)


	#main loop for all leg movement
	average_points = 0
	for i in range(N0_points): 
		average_points += cur_targ[i].position.y
		var diff = velocity
		diff.y = 0

		#adjust base positions
		if _ray_cast(to_global(base[i].position)) != {}: 
			base[i].position = to_local(_ray_cast(to_global(base[i].position))["position"])

		#checks for movement, and animation
		if (to_global(base[i].position) - cur_targ[i].position).length() > (diff.length() * 0.25) and \
		grounded[i - 1] == true and grounded[(i + 1) % len(cur_targ)] == true and grounded[i] == true:
			grounded[i] = false
			new_targ[i] = (to_global(base[i].position) + (diff.normalized() * diff.length() * 0.25))

			#adjust target positions
			if _ray_cast(new_targ[i]) != {}:
				new_targ[i] = _ray_cast(new_targ[i])["position"]

			var intermediate = to_global(base[i].position)
			intermediate.y += ((cur_targ[i].position - new_targ[i]).length()) / 2

			#animate
			tween = create_tween()
			tween.tween_property(cur_targ[i], "position", intermediate, 0.05)
			tween.tween_property(cur_targ[i], "position", new_targ[i], 0.05)
			tween.tween_callback(func(): grounded[i] = true)

	#rotation and position for body
	self.position.y = lerp(self.position.y, (average_points/4) + 2, 0.01)
	if velocity.length()> 0.1 :
		self.rotation.y = lerp_angle(self.rotation.y, atan2(velocity.x, velocity.z), 0.05)


	move_and_slide()


func _ray_cast(point):
	var params = PhysicsRayQueryParameters3D.new()
	params.from = point + Vector3(0, 2, 0)
	params.to = point + Vector3(0, -2, 0)
	var result = get_world_3d().direct_space_state.intersect_ray(params)
	return(result)
