extends KinematicBody2D

const GRAVITY = 400
var velocity = Vector2.ZERO

func _ready():
	set_physics_process(false)
	
func _physics_process(delta):
	velocity.y += GRAVITY * delta
	
	var collisions = move_and_collide(velocity*delta)
	if collisions != null:
		_on_impact(collisions.normal)

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
	
	set_physics_process(true)

func _on_impact(normal: Vector2):
	velocity = velocity.bounce(normal)
	velocity *= 0.5 + rand_range(-0.05,0.05) 
