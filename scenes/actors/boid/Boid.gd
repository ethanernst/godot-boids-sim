extends Node2D

var velocity;
var maxSpeed = 150;

func _ready():
	velocity = Vector2(randi_range(-1, 1),randi_range(-1, 1))
	
func _process(_delta):
	var speed = velocity.length()
	if (speed > maxSpeed):
		velocity = (velocity / speed) * maxSpeed
	
	position = position + (velocity * _delta)
	
	var direction = velocity.normalized()
	rotation = atan2(direction.y, direction.x)
