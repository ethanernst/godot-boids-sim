extends Node2D

var velocity;

func _ready():
	velocity = Vector2(randi_range(-1, 1),randi_range(-1, 1))
	print(velocity)
	
func _process(_delta):
	position = position * velocity
	rotation = atan2(velocity.x, velocity.y) + 2.82743

func addVelocity(newVelocity: Vector2):
	velocity = velocity + newVelocity;
