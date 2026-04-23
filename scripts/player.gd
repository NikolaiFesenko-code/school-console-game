extends CharacterBody2D
signal touched_meteor


@export var speed: float = 5.0
@export var main: Node2D
@export var damage_nodes: Array[Node2D]

var start_pos: Vector2

var is_player:bool = true

var lives: int = 3

func _ready() -> void:
	touched_meteor.connect(collision_with_meteor)
	main.reset.connect(restart)
	start_pos = global_position
	
	overhead.overhead_activ.connect(stop)
	overhead.overhead_close.connect(resume)

func _physics_process(delta: float) -> void:
	if(!overhead.overhead_is_activ):
		var moving_horizontal: float = Input.get_axis("move_left","move_right")
		var moving_vertical: float = Input.get_axis("move_top","move_bottom")
		velocity = Vector2(moving_horizontal * speed, moving_vertical * speed)
		move_and_collide(velocity)

func take_damage():
	lives -= 1
	if lives == 2:
		damage_nodes.get(0).visible = true
	elif lives == 1:
		damage_nodes.get(1).visible = true
	elif lives == 0:
		damage_nodes.get(2).visible = true
	else:
		main.lose.emit()

func collision_with_meteor():
	main.meteor_destroyed.emit()
	take_damage()

func restart():
	self.global_position = start_pos
	lives = 3
	for damage in damage_nodes:
		damage.visible = false
		
func stop():
	pass
func resume():
	pass
