extends CharacterBody2D

class_name BaseMoveEnemy

@export
var SPEED = 300.0

@export
var JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

	velocity.x = -1 * SPEED
	

	move_and_slide()

func _below(character=null) -> void:
	pass


func _die():
	queue_free()


func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.name == "hitBox":
		_below()
