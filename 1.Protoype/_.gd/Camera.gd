extends Camera3D

var char

# Called when the node enters the scene tree for the first time.
func _ready():
	char = get_node("/root/Main/Entities/CharacterBody3D")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position.x = char.position.x
	var z = self.position.z - char.position.z
	var y = self.position.y - char.position.y
	var angle = atan(z/y)
	self.rotation.x = -((PI/2) - angle)
	
