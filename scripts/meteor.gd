extends RigidBody2D

@export var collision_shape: CollisionShape2D

@export var textures: Array[Texture2D]

var main

var sprite: Sprite2D

var speed: float = 1.0
var rotation_speed: float = 0.01

var is_player:bool = false

func _ready() -> void:
	overhead.overhead_activ.connect(stop)
	overhead.overhead_close.connect(resume)
	
	sprite = $Sprite
	generate_view()

func _physics_process(delta: float) -> void:
	if !overhead.overhead_is_activ:
		var collision: KinematicCollision2D = move_and_collide(Vector2(0,1.0 * speed))
		if collision:
			var collision_object = collision.get_collider()
			if(collision_object.is_player):
				collision_object.touched_meteor.emit()
				queue_free()
	
	
	if(global_position.y > 1400):
		main.meteor_destroyed.emit()
		queue_free()
	
	rotation += rotation_speed


func generate_view():
	rotation_speed = randf_range(-0.05, 0.05)
	speed = randf_range(10.0, 10.0)
	
	var texture_id = randi_range(0, textures.size() - 1)
	sprite.texture = textures.get(texture_id)

func player_lost():
	speed = 0
	rotation_speed = 0
	
func restart():
	queue_free()
	
func stop():
	sleeping = true
func resume():
	sleeping = false
