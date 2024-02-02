extends RigidBody2D

var boids = []
var siblings = []
var viewport;

var min_speed : float = 250.0
var max_speed : float = 600.0

var seperation = 5;   # seperation distance
var alignment = 10;   # division factor for alignment
var cohesion = 1;     # division factor for cohesion

func _ready():
	# Disable gravity and collision
	gravity_scale = 0
	collision_layer = 0
	collision_mask = 0
	
	# Setup values
	linear_velocity = Vector2(randi_range(-max_speed, max_speed),randi_range(-max_speed, max_speed))
	viewport = get_viewport_rect().size
	
	# Get instantiated boids and filter out self on the next frame
	# Helps ensure all boids have been spawned
	call_deferred("_get_other_boids")

func _get_other_boids():
	boids = get_tree().get_nodes_in_group("Boids")
	for boid in boids:
		if boid != self:
			siblings.append(boid)
			
func _process(delta):
	position.x = wrapf(position.x, 0, viewport.x)
	position.y = wrapf(position.y, 0, viewport.y)
		

func _physics_process(delta):
	var direction = linear_velocity.normalized()
	rotation = atan2(direction.y, direction.x)
	
	var neighbors = []
	for i in siblings:
		if (i.position.distance_to(self.position) < Global.view_distance):
			neighbors.append(i)
	
	var seperationVector: Vector2 = calcSeperation(neighbors)
	var alignmentVector: Vector2 = calcAlignment(neighbors)
	var cohesionVector: Vector2 = calcCohesion(neighbors)
	
	var external_forces = (seperationVector + alignmentVector + cohesionVector) * delta
	
	apply_force(external_forces)

func _integrate_forces(state):
	var currentVelocity = state.get_linear_velocity()
	var currentSpeed = currentVelocity.length()
	var newSpeed = currentSpeed
	
	if (currentSpeed < min_speed):
		newSpeed = min_speed
	if (currentSpeed > max_speed):
		newSpeed = max_speed
	
	var newVelocity = currentVelocity.normalized() * newSpeed
	state.set_linear_velocity(newVelocity)

func calcSeperation(neighbors):
	var result = Vector2(0, 0)
	for i in neighbors:
		if ( i.position.distance_to(self.position) < seperation ):
			result -= (i.position - self.position)
	return result * Global.seperation_multiplier

func calcAlignment(neighbors):
	var percievedVelocity = Vector2(0, 0)
	for i in neighbors:
		percievedVelocity += i.linear_velocity
	percievedVelocity /= neighbors.size()
	
	var result : Vector2 = (percievedVelocity - self.linear_velocity) / (alignment * Global.alignment_multiplier)
	return result

func calcCohesion(neighbors):
	var percievedCenter = Vector2(0, 0)
	for i in neighbors:
		percievedCenter += i.position
	percievedCenter /= neighbors.size()
	
	var result : Vector2  = (percievedCenter - self.position) / (cohesion * Global.cohesion_multiplier)
	return result
