extends Node2D

var meteor = preload("res://scenes/meteor.tscn")

signal meteor_destroyed
signal lose
signal reset

@export var back1: Node2D
@export var back2: Node2D
@export var spawn_area: CollisionShape2D

var lose_screen: Control
var is_player_lost: bool = false

var score_label: Label
var score: int = 0
var score_timer: Timer

var end_back_pos: Vector2 = Vector2(69,1500)
var start_back_pos: Vector2 = Vector2(69,-2078.735)
var back_speed: float = 2.0

func _ready() -> void:
	lose_screen = $lose_screen
	score_label = $score_screen/HBoxContainer/Score
	score_timer = $scoring
	
	meteor_destroyed.connect(_meteor_destroyed)
	lose.connect(_lose)
	reset.connect(restart)
	
	overhead.overhead_activ.connect(stop)
	overhead.overhead_close.connect(resume)
	
	spawn_meteors(10)
	
	score_timer.start()
	

func _process(delta: float) -> void:
	back1.translate(Vector2(0,back_speed))
	back2.translate(Vector2(0,back_speed))
	
	if(back1.global_position.y > end_back_pos.y):
		back1.global_position.y = start_back_pos.y
	if(back2.global_position.y > end_back_pos.y):
		back2.global_position.y = start_back_pos.y
		
	score_label.text = "SCORE: " + str(score)


func spawn_meteor():
	var rect: Rect2 = spawn_area.shape.get_rect()
	var x = randi_range(100,1800)
	var y = randi_range(-200,-2000)
	var new_meteor = meteor.instantiate()
	new_meteor.global_position = Vector2(x,y)
	new_meteor.main = self
	lose.connect(new_meteor.player_lost)
	reset.connect(new_meteor.restart)
	add_child(new_meteor)

func spawn_meteors(count: int):
	for i in range(0, count):
		spawn_meteor()

func _meteor_destroyed():
	spawn_meteor()

	
func _lose():
	lose_screen.visible = true
	is_player_lost = true
	score_timer.stop()
	
func restart():
	spawn_meteors(10)
	lose_screen.visible = false
	is_player_lost = false
	score = 0
	score_timer.start()

func _input(event: InputEvent) -> void:
	if  !overhead.overhead_is_activ:
		if event.is_action_released("Y"):
			if is_player_lost:
				reset.emit()


func _on_scoring_timeout() -> void:
	score += 1
	
func stop():
	back_speed = 0
	score_timer.stop()
func resume():
	back_speed = 2.0
	if !is_player_lost:
		score_timer.start()
