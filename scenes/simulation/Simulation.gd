extends Node2D

@export var boidCount : int = 50

var boidScene = preload("res://scenes/boid/Boid.tscn")
var viewport;
var padding = 50;

func _ready():
	call_deferred("getViewportSize")

func getViewportSize():
	viewport = get_viewport_rect().size
	print("Viewport size: ", viewport)
	initializeBoids()

func initializeBoids():
	for i in range(boidCount):
		var newBoid = boidScene.instantiate()
		newBoid.position = Vector2(randi_range(padding, viewport.x - padding),randi_range(padding, viewport.y - padding))
		newBoid.add_to_group("Boids")
		add_child(newBoid)

func _process(_delta):
	pass
