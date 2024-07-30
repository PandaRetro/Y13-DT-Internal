extends Node3D

@onready var skel = $Armature/Skeleton3D
@onready var top_nodes = skel.get_parentless_bones()
var edges
var angle
var dist
var BONE_LEN

func _ready():

	top_nodes.remove_at(0)
	top_nodes.remove_at(1)
	top_nodes.remove_at(1)
	top_nodes.remove_at(1)

	BONE_LEN = (to_global(skel.get_bone_pose_position(top_nodes[0]))\
	- to_global(skel.get_bone_pose_position(top_nodes[0] + 1))).length()
	dist = (3* BONE_LEN)

func _process(delta):

	for i in top_nodes:
		var collisons = []
		collisons.append(_ray_cast(to_global(skel.get_bone_pose_position(i)), to_global(skel.get_bone_pose_position(i))))
		var list = []
		var current
		for j in range(3):
			if j == 0: 
				current = skel.get_bone_children(i)[0]
			else:
				current = skel.get_bone_children(current)[0]
			list.append(current) # just need to get the raycasts for the child nodes and then pick one
		print(list)
#		print(collisons)

	if dist < (3* BONE_LEN) and dist > 0:
		angle = acos((dist - BONE_LEN) / (2*BONE_LEN))
	else:
		angle = 0

	skel.set_bone_pose_rotation(2, Quaternion(lerp(skel.get_bone_pose_rotation(2).x,float(angle),0.3), 0, 0, 1))
	skel.set_bone_pose_rotation(3, Quaternion(lerp(skel.get_bone_pose_rotation(3).x,float(-angle),0.3), 0, 0, 1))
	skel.set_bone_pose_rotation(4, Quaternion(lerp(skel.get_bone_pose_rotation(4).x,float(-angle),0.1), 0, 0, 1))

	if Input.is_action_just_pressed("ui_up"):
		dist += (BONE_LEN / 3)
		print(dist)

	if Input.is_action_just_pressed("ui_down"):
		dist -= (BONE_LEN / 3)
		print(dist)

	if Input.is_action_just_pressed("ui_left"):
		print(BONE_LEN)
		print(dist)
		print((dist - BONE_LEN) / (2*BONE_LEN))
		print(acos((dist - BONE_LEN) / (2*BONE_LEN)))
		print(angle)


func _ray_cast(pos, pivot):

	var diff = pos - pivot
	diff.y = 0 
	var ray_cast_len = sin(acos(diff.length() / (3*BONE_LEN))) * (3*BONE_LEN)
	var params = PhysicsRayQueryParameters3D.new()
	params.from = pos
	params.to = pos + Vector3(0,-(ray_cast_len + (pos.y - pivot.y)), 0)
	var result = get_world_3d().direct_space_state.intersect_ray(params)
	return(result)
