extends Node3D

@onready var skel = $Armature/Skeleton3D
@onready var character = get_node('/root/Main/Entities/CharacterBody3D')

var target_pos
var limbs = 10
var limb_len 
var iterations = 10

func _ready():
	pass 



func _process(delta):
	target_pos = to_local(character.pos)
	if target_pos.length() > (limb_len *limbs):
		target_pos = target_pos.normalized() * (limb_len * limbs)

	var cur_pos = []
	var index
	for i in range(skel.get_bone_count()):
		if i > 0:
			index = skel.get_bone_children(index)[0]
		else:
			index = 0
		cur_pos.append(skel.get_bone_global_pose(index).origin)

	cur_pos.append(target_pos)
	for iteration in iterations:
		for i in range(skel.get_bone_count()):
			var j = len(cur_pos) - (i + 1)
			var diff_in_points_backward
			diff_in_points_backward = cur_pos[j - 1] - cur_pos[j]
			if diff_in_points_backward.length() != limb_len:
				cur_pos[j - 1] = cur_pos[j] + (diff_in_points_backward.normalized() * limb_len)


		if cur_pos[0].length() != 0:
			cur_pos[0] = Vector3(0, 0, 0)
		for i in range((skel.get_bone_count() - 1)):
			var diff_in_points_forward
			diff_in_points_forward = cur_pos[i + 1] - cur_pos[i]
			if diff_in_points_forward.length() != limb_len:
				cur_pos[i + 1] = cur_pos[i] + (diff_in_points_forward.normalized() * limb_len)







