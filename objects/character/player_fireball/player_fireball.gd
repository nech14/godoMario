extends CharacterBody2D

class_name PlayerFireball

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -200.0
var duration = 1
@onready var anim = $AnimatedSprite2D

var previous_x_position: float
var stuck_timer: float = 0.0
const STUCK_THRESHOLD: float = 0.05  # Время, которое нужно провести в неподвижном состоянии, чтобы исчезнуть

func _ready():
	previous_x_position = position.x

func _physics_process(delta: float) -> void:
	
	velocity.x = duration * SPEED
	if(duration < 0):
		anim.flip_h = true
	elif anim.flip_h:
		anim.flip_h = false
		
	anim.play("default")
	
	if not is_on_floor():
		velocity += get_gravity() * delta 
	
	if is_on_floor():
		velocity.y = velocity.y + JUMP_VELOCITY
	
	move_and_slide()
	
	# Проверка застревания
	if abs(position.x - previous_x_position) < 0.1:  # Если положение почти не меняется
		stuck_timer += delta
		if stuck_timer >= STUCK_THRESHOLD:
			queue_free()  # Удаление объекта
	else:
		stuck_timer = 0.0  # Сброс таймера при движении

	# Обновление предыдущей позиции
	previous_x_position = position.x
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body._die()
		queue_free()
	elif body != self and body is PlayerFireball:
		queue_free()
	elif body.is_in_group("block"):
		var delta = body.position - position
		if abs(delta.x) > abs(delta.y) and velocity.x != 0:
			queue_free()
