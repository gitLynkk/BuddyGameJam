extends Node
class_name PhysicsHelper

static func calculate_arc_velocity(point_a, point_b, arc_height,\
 gravity_up = 300, gravity_down = null):
	
	if gravity_down == null:
		gravity_down = gravity_up
		
	var velocity = Vector2()
	
	var displacement = point_b - point_a
	
	var time_up = sqrt(-2 * arc_height / float(gravity_up))
	var time_down = sqrt(2 * (displacement.y - arc_height)/float(gravity_down))
		
	velocity.y = -sqrt(-2 * gravity_up * arc_height)
	velocity.x = displacement.x / float(time_up + time_down)
	
	return velocity
