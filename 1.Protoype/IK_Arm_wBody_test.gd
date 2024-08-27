extends CharacterBody3D

var base
var cur_targ
var new_targ = []
var tween

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var N0_points
var jump_dist = 3
var gravity = 0 #ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready():
	base = $Points/Base.get_children()
	cur_targ = $Points/Targets.get_children()
	N0_points = len(base)
	for i in range(N0_points):
		cur_targ[i].position = to_global(base[i].position)
		new_targ.append(cur_targ[i].position)


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
		if (to_global(base[i].position) - cur_targ[i].position).length() > jump_dist:
			new_targ[i] = (to_global(base[i].position) + (diff.normalized() * jump_dist * 0.5))

		if cur_targ[i].position != new_targ[i]:
			#cur_targ[i].position = lerp(cur_targ[i].position, new_targ[i], 0.2)
			_animate(cur_targ[i], new_targ[i])


	move_and_slide()

func _animate(point, new_targ):
	#if tween:
		#tween.kill()
	tween = create_tween()
	tween.tween_property(point, "position", new_targ, 0.5)
	tween.TRANS_EXPO
	tween.EASE_OUT
	#tween.interpolate_value(point.position, new_targ, 0, 0.5, Tween.TRANS_EXPO, Tween.EASE_OUT)
