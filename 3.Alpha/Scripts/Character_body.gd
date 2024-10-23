extends CharacterBody3D

var save_path = "user://variable.save"

var self_position
var ray_casts
var tween
var average_points
var bases = []
var cur_targ = []
var new_targ = []
var grounded = []

const N0_LEGS = 8
const SPEED = 3.0


func _ready():
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
	if direction and _ray_cast(direction.normalized() + self.position):
		velocity.z = direction.z * SPEED
		velocity.x = direction.x * SPEED
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	#Main loop for all leg movement
	average_points = 0
	for i in range(len(bases)): 
		average_points += cur_targ[i].position.y
		var diff = velocity
		diff.y = 0

		#Adjust base positions
		if _ray_cast(bases[i].global_position) != {}: 
			bases[i].global_position = _ray_cast(bases[i].global_position)["position"]

		#Leg movement checks
		if (
				(bases[i].global_position - cur_targ[i].position).length() > (diff.length() * 0.25) 
				and grounded[i - 2] == true
				and grounded[(i + 2) % len(cur_targ)] == true
				and grounded[i] == true
		):
			grounded[i] = false
			new_targ[i] = (bases[i].global_position + (diff.normalized() * diff.length() * 0.25))

			#Adjust target positions
			if _ray_cast(new_targ[i]) != {}:
				new_targ[i] = _ray_cast(new_targ[i])["position"]

			#Choose intermediate position
			var intermediate = bases[i].global_position
			intermediate.y += ((cur_targ[i].position - new_targ[i]).length()) / 4

			#Animate
			tween = create_tween()
			tween.tween_property(cur_targ[i], "position", intermediate, 0.1)
			tween.tween_property(cur_targ[i], "position", new_targ[i], 0.1)
			tween.tween_callback(func(): grounded[i] = true)

	#Rotation and position for body
	self.position.y = lerp(self.position.y, _ray_cast(self.position - Vector3(0, 2, 0))["position"].y + 1.25, 0.1)
	if velocity.length()> 0.1 :
		self.rotation.y = lerp_angle(self.rotation.y, atan2(velocity.x, velocity.z), 0.05)

	move_and_slide()


func _ray_cast(point):
	var params = PhysicsRayQueryParameters3D.new()
	params.from = point + Vector3(0, 2, 0)
	params.to = point + Vector3(0, -3, 0)
	params.collision_mask = 2
	var result = get_world_3d().direct_space_state.intersect_ray(params)
	return(result)

func _save():
	self_position = self.position
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(self_position)
	
func _load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		self.position = file.get_var(self_position)
	else:
		self.postion = Vector3(0, 1.5, 0)
