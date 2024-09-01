extends CharacterBody3D

var base = []
var cur_targ = []
var new_targ = []
var tween
var curve
var grounded = []
var N0_points
var gravity = 0 #ProjectSettings.get_setting("physics/3d/default_gravity")


const SPEED = 5.0
const JUMP_VELOCITY = 4.5



func _ready():
	base = $Points/Base.get_children()
	N0_points = len(base)
	for i in range(N0_points):
		cur_targ.append($Points/Targets.get_child(i).get_child(0).get_child(0))
		cur_targ[i].position = to_global(base[i].position)
		new_targ.append(cur_targ[i].position)
		grounded.append(true)


func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta


	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY


	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)


	for i in range(N0_points):
		var diff = velocity
		diff.y = 0
		if (to_global(base[i].position) - cur_targ[i].position).length() > (diff.length() * 0.25):
			if grounded[i - 1] == true and grounded[(i + 1) % len(cur_targ)] == true:
				grounded[i] = false
				var intermediate = to_global(base[i].position)
				intermediate.y += 2
				new_targ[i] = (to_global(base[i].position) + (diff.normalized() * diff.length() * 0.25))
				_animate(cur_targ, new_targ, intermediate, i)


	move_and_slide()


func _animate(cur_targ, new_targ, intermediate, index):
	
	curve = Curve3D.new()
	curve.add_point(cur_targ[index].position, cur_targ[index].position, intermediate)
	curve.add_point(new_targ[index], intermediate, new_targ[index])
	$Points/Targets.get_child(index).curve = curve
	tween = create_tween()
	#tween.tween_property(point[index], "position", intermediate, 0.05)
	tween.tween_property(cur_targ[index], "position", new_targ[index], 0.1)
	await tween.finished
	grounded[index] = true
	#tween.interpolate_value(point.position, new_targ, 0, 0.5, Tween.TRANS_EXPO, Tween.EASE_OUT)
