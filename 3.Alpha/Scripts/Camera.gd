extends Camera3D

var char


func _ready():
	char = get_node("/root/Main/Character")


func _process(delta):
	# Follow player and rotate to keep in frame
	self.position.x = lerp(self.position.x, char.position.x, 0.05)
	var z = self.position.z - char.position.z
	var y = self.position.y - char.position.y
	var angle = atan(z/y)
	self.rotation.x = lerp(self.rotation.x, -((PI/2) - angle), 0.05)
