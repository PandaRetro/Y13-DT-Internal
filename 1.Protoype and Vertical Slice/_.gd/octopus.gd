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

	BONE_LEN = (to_global(skel.get_bone_global_pose(top_nodes[0]).origin)\
	- to_global(skel.get_bone_global_pose(top_nodes[0] + 1).origin)).length()


func _process(delta):
	if Input.is_action_just_pressed("ui_left"):
		var point_info = _get_target_pos(1)
		print(point_info)
		dist = point_info[2] 
		var norm = point_info[1] - to_global(self.position)
		norm.y = 0
		var point = point_info[0]
		var pivot_rotation = -acos((norm.dot(point_info[0])) / (norm.length() * point_info[0].length()))
		print("----------------------------")
		print(point)
		print(pivot_rotation)
		skel.set_bone_pose_rotation(1, Quaternion(lerp(skel.get_bone_pose_rotation(1).x, float(pivot_rotation) + -0.708,1), 0, 0, 1))
		
		
		if dist < (3* BONE_LEN) and dist > 0:
			angle = acos((dist - BONE_LEN) / (2*BONE_LEN))
		else:
			angle = 0

		skel.set_bone_pose_rotation(2, Quaternion(lerp(skel.get_bone_pose_rotation(2).x,float(angle),1), 0, 0, 1))
		skel.set_bone_pose_rotation(3, Quaternion(lerp(skel.get_bone_pose_rotation(3).x,float(-angle),1), 0, 0, 1))
		skel.set_bone_pose_rotation(4, Quaternion(lerp(skel.get_bone_pose_rotation(4).x,float(-angle),1), 0, 0, 1))


func _ray_cast(pos, pivot_pos):
	var diff = pos - pivot_pos
	diff.y = 0 
	var ray_cast_len = sin(acos(diff.length() / (3*BONE_LEN))) * (3*BONE_LEN)
	var params = PhysicsRayQueryParameters3D.new()
	params.from = pos
	params.to = pos + Vector3(0,-(ray_cast_len + (pos.y - pivot_pos.y)), 0)
	var result = get_world_3d().direct_space_state.intersect_ray(params)
	return(result)


func _get_target_pos(pivot_index):
	var collisons = []
	var pivot_pos = to_global(skel.get_bone_global_pose(pivot_index).origin)
	var ray_res = _ray_cast(pivot_pos, pivot_pos)
	if ray_res != {}:
		collisons.append(ray_res["position"])

	var current
	for i in range(3):
		if i == 0: 
			current = skel.get_bone_children(pivot_index)[0]
		else:
			current = skel.get_bone_children(current)[0]
		ray_res = _ray_cast(to_global(skel.get_bone_global_pose(current).origin), pivot_pos)
		if ray_res != {}:
			collisons.append(ray_res["position"])

	var cur_closest_pt
	var cur_length = 3*BONE_LEN
	for i in collisons:
		if (i - pivot_pos).length() < cur_length:
			cur_closest_pt = i
			cur_length = (i - pivot_pos).length()

	return([cur_closest_pt, pivot_pos, cur_length])










