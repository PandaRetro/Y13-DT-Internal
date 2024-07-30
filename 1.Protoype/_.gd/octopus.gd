extends Node3D


const BONE_LEN = 14.0

@onready var skel = $Armature/Skeleton3D
var angle
var other_angle
var dist = 42.0


func _ready():
	var list = $Armature/Skeleton3D.find_bone("Bone.003")
	print(list)
	print($Armature/Skeleton3D.get_bone_pose_rotation(list))


func _process(delta):
	
	
	if dist < 42 and dist > 0:
		angle = acos((dist - BONE_LEN) / (2*BONE_LEN))
		other_angle = angle - (PI/2)
	else:
		angle = 0

	skel.set_bone_pose_rotation(2, Quaternion(lerp(skel.get_bone_pose_rotation(2).x,float(angle),0.3), 0, 0, 1))
	skel.set_bone_pose_rotation(3, Quaternion(lerp(skel.get_bone_pose_rotation(3).x,float(-angle),0.3), 0, 0, 1))
	skel.set_bone_pose_rotation(4, Quaternion(lerp(skel.get_bone_pose_rotation(4).x,float(-angle),0.1), 0, 0, 1))

	if Input.is_action_just_pressed("ui_up"):
		dist += 1
		print(dist)

	if Input.is_action_just_pressed("ui_down"):
		dist -= 1
		print(dist)

	if Input.is_action_just_pressed("ui_left"):
		print(BONE_LEN)
		print(dist)
		print((dist - BONE_LEN) / (2*BONE_LEN))
		print(acos((dist - BONE_LEN) / (2*BONE_LEN)))
		print(angle)
