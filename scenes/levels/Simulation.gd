extends Node2D

@export var boidCount : int = 100
@export_range(0.5, 1.5, 1.0) var seperation_multiplier : float = 1.0;
@export_range(0.5, 1.5, 1.0) var alignment_multiplier : float = 1.0;
@export_range(0.5, 1.5, 1.0) var cohesion_multiplier : float = 1.0;

var boidScene = preload("res://scenes/actors/boid/Boid.tscn")
var viewport;
var boids = [];
var padding = 50;

var seperation = 50; # seperation distance
var alignment = 200;  # division factor for alignment (200 = 0.5%)
var cohesion = 20;    # division factor for cohesion (10 = 0.5%)

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
		newBoid.velocity = Vector2(randi_range(padding, viewport.x - padding),randi_range(padding, viewport.y - padding))
		boids.append(newBoid)
		add_child(newBoid)
	print("Boids: ", boids)

func _process(_delta):
	for boidInstance in boids:
		var seperationVector: Vector2 = calcSeperation(boidInstance)
		var alignmentVector: Vector2 = calcAlignment(boidInstance)
		var cohesionVector: Vector2 = calcCohesion(boidInstance)
		boidInstance.velocity += (alignmentVector + cohesionVector + seperationVector)

func calcSeperation(currentBoid):
	var result : Vector2
	for i in boids:
		if (i != currentBoid):
			if ( i.position.distance_to(currentBoid.position) < (seperation * seperation_multiplier) ):
				result -= (i.position - currentBoid.position)
	return result

func calcAlignment(currentBoid):
	var percievedVelocity : Vector2
	for i in boids:
		if (i != currentBoid):
			percievedVelocity += i.velocity
	percievedVelocity /= (boids.size() - 1)
	
	var result : Vector2 = (percievedVelocity - currentBoid.velocity) / (alignment * alignment_multiplier)
	return result

func calcCohesion(currentBoid):
	var percievedCenter : Vector2
	for i in boids:
		if (i != currentBoid):
			percievedCenter += i.position
	percievedCenter /= (boids.size() - 1)
	
	var result : Vector2  = (percievedCenter - currentBoid.position) / (200 * cohesion_multiplier)
	return result

# MULTIPLIER SLIDERS

func _on_seperation_slider_value_changed(value):
	seperation_multiplier = value

func _on_alignment_slider_value_changed(value):
	alignment_multiplier = value

func _on_cohesion_slider_value_changed(value):
	cohesion_multiplier = value
