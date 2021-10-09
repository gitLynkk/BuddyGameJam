extends KinematicBody2D

var plSeed := preload("res://Nodes/Seed.tscn")

const ACCELERATION = 512
const MAX_SPEED = 64
const FRICTION = 0.25
const AIR_RESISTANCE = 0.02
const GRAVITY = 400
const JUMP_FORCE = 170
const DOWN_FORCE = 80

var seedsOut = 0

var motion = Vector2.ZERO

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer 
onready var throwBeginning = $ThrowBeginning

func processInput(delta):
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if x_input != 0:
		animationPlayer.play("Run")
		motion.x += x_input * ACCELERATION * delta
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
		#look_right(x_input < 0)
	else:
		animationPlayer.play("Stand")
		motion.x = lerp(motion.x,0,FRICTION)
		
	motion.y += GRAVITY * delta
	
	if is_on_floor():
		if x_input == 0:
			motion.x  = lerp(motion.x,0,FRICTION)
			
		if Input.is_action_just_pressed("ui_up"):
			motion.y = -JUMP_FORCE
	else:
		animationPlayer.play("Jump")
		if Input.is_action_just_released("ui_up") and motion.y < -JUMP_FORCE/2:
			motion.y = -JUMP_FORCE/2
		elif Input.is_action_just_pressed("ui_down"):
			motion.y += DOWN_FORCE
		
		if x_input == 0:
			motion.x = lerp(motion.x,0,AIR_RESISTANCE)

func _physics_process(delta):
	processInput(delta);
	motion = move_and_slide(motion,Vector2.UP)

func _process(delta):
	if Input.is_action_just_pressed("throw") && seedsOut < 1:
		throwSeed()
	
	look_right(global_position.x > get_global_mouse_position().x)

func look_right(looking_right: bool):
	sprite.flip_h = looking_right

func throwSeed():
		var seedThrowing = plSeed.instance()
		get_tree().current_scene.add_child(seedThrowing)
		seedThrowing.global_position = throwBeginning.global_position
		seedThrowing.launch(get_global_mouse_position())
		seedsOut+=1
