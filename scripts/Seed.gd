extends KinematicBody2D

const MAX_BOUNCES = 1

const ACCELERATION = 512
const MAX_SPEED = 64
const FRICTION = 0.25
const AIR_RESISTANCE = 0.02
const GRAVITY = 400
const JUMP_FORCE = 170
const DOWN_FORCE = 80

var seedsOut = 0

var motion = Vector2.ZERO

var velocity = Vector2.ZERO
var bounces = 0

var isControllable = false

func processInput(delta):
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if x_input != 0:
		motion.x += x_input * ACCELERATION * delta
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
		#look_right(x_input < 0)
	else:
		motion.x = lerp(motion.x,0,FRICTION)
		
	
	if is_on_floor():
		if x_input == 0:
			motion.x  = lerp(motion.x,0,FRICTION)
			
		if Input.is_action_just_pressed("ui_up"):
			motion.y = -JUMP_FORCE
	else:
		if Input.is_action_just_released("ui_up") and motion.y < -JUMP_FORCE/2:
			motion.y = -JUMP_FORCE/2
		elif Input.is_action_just_pressed("ui_down"):
			motion.y += DOWN_FORCE
		
		if x_input == 0:
			motion.x = lerp(motion.x,0,AIR_RESISTANCE)

func _physics_process(delta):
	if not isControllable:
		velocity.y += GRAVITY * delta
		var collisions = move_and_collide(velocity*delta)
		if collisions != null:
			_on_impact(collisions.normal)
	else:
		processInput(delta)
		motion.y += GRAVITY * delta
		motion = move_and_slide(motion,Vector2.UP)

func launch(target_position):
	var temp = global_transform
	var scene = get_tree().current_scene
	get_parent().remove_child(self)
	scene.add_child(self)
	global_transform = temp

	var arc_height = target_position.y - global_position.y - 16
	arc_height = min(arc_height, -16)
	velocity = PhysicsHelper.calculate_arc_velocity(global_position, target_position, arc_height, GRAVITY, GRAVITY*1.5)
	velocity = velocity.clamped(400)
	velocity = velocity.rotated(rand_range(-0.05,0.05))

func _on_impact(normal: Vector2):
	if bounces < MAX_BOUNCES:
		velocity = velocity.bounce(normal)
		velocity *= 0.5 + rand_range(-0.05,0.05) 
		bounces += 1
	else:
		velocity = Vector2.ZERO
		isControllable = true
