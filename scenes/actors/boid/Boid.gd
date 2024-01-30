extends RigidBody2D

var boids = []
var siblings = []

var max_speed = 150;

var seperation = 5;   # seperation distance
var alignment = 10;   # division factor for alignment (200 = 0.5%)
var cohesion = 1;     # division factor for cohesion (10 = 0.5%)

var seperation_multiplier : float = 1.0;
var alignment_multiplier : float = 1.0;
var cohesion_multiplier : float = 1.0;

func _ready():
	# Disable gravity and collision
	gravity_scale = 0
	collision_layer = 0
	collision_mask = 0
	
	# Setup values
	linear_velocity = Vector2(randi_range(-max_speed, max_speed),randi_range(-max_speed, max_speed))
	
	# Get instantiated boids and filter out self on the next frame
	# Helps ensure all boids have been spawned
	call_deferred("_get_other_boids")

func _get_other_boids():
	boids = get_tree().get_nodes_in_group("Boids")
	for boid in boids:
		if boid != self:
			siblings.append(boid)

func _process(delta):
	var direction = linear_velocity.normalized()
	rotation = atan2(direction.y, direction.x)
	
	var seperationVector: Vector2 = calcSeperation()
	var alignmentVector: Vector2 = calcAlignment()
	var cohesionVector: Vector2 = calcCohesion()
	
	var external_forces = (seperationVector + alignmentVector + cohesionVector) * delta
	
	apply_force(external_forces)

func calcSeperation():
	var result = Vector2(0, 0)
	for i in siblings:
		if ( i.position.distance_to(self.position) < (seperation * seperation_multiplier) ):
			result -= (i.position - self.position)
	return result

func calcAlignment():
	var percievedVelocity = Vector2(0, 0)
	for i in siblings:
		percievedVelocity += i.linear_velocity
	percievedVelocity /= siblings.size()
	
	var result : Vector2 = (percievedVelocity - self.linear_velocity) / (alignment * alignment_multiplier)
	return result

func calcCohesion():
	var percievedCenter = Vector2(0, 0)
	for i in siblings:
		percievedCenter += i.position
	percievedCenter /= siblings.size()
	
	var result : Vector2  = (percievedCenter - self.position) / (cohesion * cohesion_multiplier)
	return result

# MULTIPLIER SLIDERS
func _on_seperation_slider_value_changed(value):
	seperation_multiplier = value

func _on_alignment_slider_value_changed(value):
	alignment_multiplier = value

func _on_cohesion_slider_value_changed(value):
	cohesion_multiplier = value
