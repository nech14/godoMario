
extends BaseMoveEnemy

@onready var anim = $AnimatedSprite2D
var die = false

@export var start_point = Vector2(0,0)
@export var end_point = Vector2(0,0)


var moving_to_end = true  # Направление движения

func _physics_process(delta: float) -> void:
	if die:
		return
		
	var target_position = end_point if moving_to_end else start_point
	
	# Двигаемся к цели
	var direction = (target_position - position).normalized()
	#position += direction * SPEED * delta
	
	# Проверяем достижение цели
	if position.distance_to(target_position) < 5:  # Допуск в 5 пикселей
		moving_to_end = not moving_to_end  # Меняем направление

	velocity = direction * SPEED
	
	if direction.x < 0:
		anim.flip_h = false
	elif !anim.flip_h:
		anim.flip_h = true
		
	
	anim.play("default")

	move_and_slide()

func _below(character=null) -> void:
	pass
	
func _die(character=null) -> void:
	if character != null:
		character._on_jump()
	die = true
	queue_free()
	
func _cause_damage(character=null) -> void:
	character._take_damage()


func _on_hit_box_area_entered(area: Area2D) -> void:
	if die:
		return
		
	if area.name == "hitBox" and area.get_parent().name == "Player":
		var direction = area.global_position - global_position

		# Определяем, с какой стороны произошло столкновение
		if abs(direction.y) > abs(direction.x):  # Вертикальное столкновение
			if direction.y > 0:  # Блок ниже
				print("Блок задет снизу!")
				_cause_damage(area.get_parent())
			elif direction.y < 0:  # Блок выше
				print("Блок задет сверху!")
				_die(area.get_parent())
		else:  # Горизонтальное столкновение
			if direction.x > 0:  # Блок справа
				print("Блок задет справа!")
				_cause_damage(area.get_parent())
			elif direction.x < 0:  # Блок слева
				print("Блок задет слева!")
				_cause_damage(area.get_parent())

	
		


func _on_eyes_body_entered(body: Node2D) -> void:
	if body.is_in_group("block"):
		moving_to_end = not moving_to_end
		#direction = -direction


func _on_animated_sprite_2d_animation_finished() -> void:
	if die:
		queue_free()
