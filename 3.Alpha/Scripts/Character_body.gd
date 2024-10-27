extends CharacterBody3D

var save_path = "user://variable.save"

var self_position
var tween

var bases = []
var cur_targ = []
var new_targ = []
var grounded = []

var step_dist_factor = 0.25
var step_height_factor = 0.25
var leg_animation_duration = 0.1
var body_adjustment_weight = 0.1
var body_rotation_weight = 0.05
var raycast_start = Vector3(0, 2, 0)
var raycast_end = Vector3(0, -3, 0)
var raycast_coll_mask = 2

const N0_LEGS = 8
const SPEED = 180.0
const BASE_HEIGHT = 1.25


func _ready():
	load_data()
	for i in range(N0_LEGS):
		var arm = $Arms.get_children()[i]
		bases.append(arm.get_child(1))
		cur_targ.append(arm.get_child(2))
		cur_targ[i].position = bases[i].global_position
		new_targ.append(cur_targ[i].position)
		grounded.append(true)


func _physics_process(delta):

	# Character movement
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
	if direction and ray_cast(direction.normalized() + self.position):
		velocity.z = direction.z * SPEED * delta
		velocity.x = direction.x * SPEED * delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	# Main loop for individual leg movement
	for i in range(N0_LEGS): 
		var hori_vel = Vector3(velocity.x, 0, velocity.z)
		var step_dist_check = hori_vel.length() * step_dist_factor

		# Adjust base positions
		if ray_cast(bases[i].global_position) != {}: 
			bases[i].global_position = ray_cast(bases[i].global_position)["position"]

		# Leg movement checks
		if (
				(bases[i].global_position - cur_targ[i].position).length() > step_dist_check
				and grounded[i - 2] == true 
				and grounded[(i + 2) % len(cur_targ)] == true
				and grounded[i] == true
		):
			grounded[i] = false
			new_targ[i] = (bases[i].global_position + (hori_vel.normalized() * step_dist_check))

			# Adjust target positions
			if ray_cast(new_targ[i]) != {}:
				new_targ[i] = ray_cast(new_targ[i])["position"]

			# Animate in arch using raised halfway point
			var intermediate = bases[i].global_position
			intermediate.y += ((cur_targ[i].position - new_targ[i]).length()) * step_height_factor
			tween = create_tween()
			tween.tween_property(cur_targ[i], "position", intermediate, leg_animation_duration)
			tween.tween_property(cur_targ[i], "position", new_targ[i], leg_animation_duration)
			tween.tween_callback(func(): grounded[i] = true)

	# Lerp rotation and position for body
	var new_pos = ray_cast(self.position - raycast_start)["position"].y + BASE_HEIGHT
	self.position.y = lerp(self.position.y, new_pos, body_adjustment_weight)
	if velocity.length()> 0 :
		var new_angle = atan2(velocity.x, velocity.z)
		self.rotation.y = lerp_angle(self.rotation.y, new_angle, body_rotation_weight)

	move_and_slide()

	# Exit to home
	if Input.is_action_just_pressed("ui_escape"):
		save()
		get_tree().change_scene_to_file("res://Scenes/Home_Screen.tscn")

# Checks vertical area around point for available 'floor'
func ray_cast(point):
	var params = PhysicsRayQueryParameters3D.new()
	params.from = point + raycast_start
	params.to = point + raycast_end
	params.collision_mask = raycast_coll_mask
	var result = get_world_3d().direct_space_state.intersect_ray(params)
	return(result)

# Stores player position
func save():
	print(self.global_transform.origin)
	self_position = self.global_transform.origin
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(self_position)

# loads player position
func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		self.global_transform.origin = file.get_var()
	else:
		self.global_transform.origin = Vector3(0, BASE_HEIGHT, 0)
