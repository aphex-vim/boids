extends Node2D

export(PackedScene) var Boid

export var number_of_boids := 200
export var margin := 100
var screen_size := Vector2.ZERO

func _ready():
	screen_size = get_viewport_rect().size
	
	# seeding randomizer for spawn location
	randomize()
	
	# spawning boids
	for i in number_of_boids:
		spawn_boid()

func spawn_boid():
		
	# init new boid
	var boid : Area2D = preload("res://actors/boid.tscn").instance()
		
	# randomizing color
	boid.modulate = Color(randf(), randf(), randf(), 1)
	
	# spawning in a random location
	boid.global_position = Vector2(rand_range(0+margin, screen_size.x-margin), rand_range(0+margin, screen_size.y-margin))
