extends Area2D

var flock := []
var velocity := Vector2.ZERO
var screen_size := Vector2.ZERO
var speed := 2

func _ready():
	
	# setting screen size
	screen_size = get_viewport_rect().size
	
	# seeding randomizer
	randomize()
	
	# setting random velocity
	self.velocity = Vector2(rand_range(-1,1), rand_range(-1,1))

func _physics_process(delta):
	screenwrap()
	adjust_for_flock()
#	adjust_for_walls()
	
	self.velocity = velocity.normalized() * speed
	self.rotation = lerp_angle(rotation, self.velocity.angle_to_point(Vector2.ZERO), 0.4)

# detecting boids entering/exiting vision
func _on_vision_area_entered(area):
	if area != self && area.is_in_group("boid"):
		self.flock.append(area)

func _on_vision_area_shape_exited(area_id, area, area_shape, local_shape):
	self.flock.erase(area)

# adjusting for boids in the flock
func adjust_for_flock():
	
	#if there's another boid in the flock
	if flock:
		var flock_avg_velocity := Vector2.ZERO
		var flock_center := Vector2.ZERO
		var avoidance_vector := Vector2.ZERO
		
		# looking at each boid in the flock
		for boid in flock:
			flock_avg_velocity += boid.velocity
			flock_center += boid.position
			avoidance_vector -= (boid.global_position - self.global_position) * .2/(self.global_position - boid.global_position).length()
			
		# steering the boid to move towards the center of the flock
		flock_center /= flock.size()
		self.velocity += (flock_center - self.position)/100
		
		# steering the boid to align with the direction of the flock
		flock_avg_velocity /= flock.size()
		self.velocity += (flock_avg_velocity - self.velocity)/2
		
		# steering away from nearby flock members
		avoidance_vector /= flock.size()
		self.velocity += avoidance_vector

# handles wrapping when screen doesn't have boundaries
func screenwrap():
	global_position += velocity
	
	if global_position.x < 0:
		global_position.x = screen_size.x
		
	if global_position.y < 0:
		global_position.y = screen_size.y
		
	if global_position.x > screen_size.x:
		global_position.x = 0
		
	if global_position.y > screen_size.y:
		global_position.y
