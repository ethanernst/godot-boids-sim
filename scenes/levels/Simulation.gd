extends Node2D

@export var boidCount : int = 20
@export_range(0.0, 1.0, 0.5) var alignment : float = 0.5;
@export_range(0.0, 1.0, 0.5) var cohesion : float = 0.5;
@export_range(0.0, 1.0, 0.5) var seperation : float = 0.5;

var boidScene = preload("res://scenes/actors/boid/Boid.tscn")
var viewport;
var boids = [];

func _ready():
	call_deferred("getViewportSize")

func getViewportSize():
	viewport = get_viewport_rect().size
	print("Viewport size: ", viewport)
	initializeBoids()

func initializeBoids():
	for i in range(boidCount):
		var newBoid = boidScene.instantiate()
		newBoid.position = Vector2(randi_range(0, viewport.x),randi_range(0, viewport.y))
		newBoid.velocity = Vector2(randi_range(0, viewport.x),randi_range(0, viewport.y))
		boids.append(newBoid)
		add_child(newBoid)
	print("Boids: ", boids)

func _process(_delta):
	for boidInstance in boids:
		var seperationVector: Vector2 = calcSeperation(boidInstance)
		var alignmentVector: Vector2 = calcAlignment(boidInstance)
		var cohesionVector: Vector2 = calcCohesion(boidInstance)
		boidInstance.addVelocity(seperationVector + alignmentVector + cohesionVector)

func calcSeperation(currentBoid):
	return(Vector2(0,0))
	
func calcAlignment(currentBoid):
	return(Vector2(0,0))
	
func calcCohesion(currentBoid):
	return(Vector2(0,0))
