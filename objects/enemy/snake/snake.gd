
extends BaseMoveEnemy

var direction = -1 

func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta

	velocity.x = direction * SPEED
	

	move_and_slide()

func _below(character=null) -> void:
	
	pass
	
func _die(character=null) -> void:
	if character != null:
		character._on_jump()
	queue_free()
	
func _cause_damage(character=null) -> void:
	character._take_damage()


func _on_hit_box_area_entered(area: Area2D) -> void:
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
		direction = -direction
