
extends BaseMoveEnemy

var direction = 1 
@onready var anim = $AnimatedSprite2D
var die = false


func _physics_process(delta: float) -> void:
	if die:
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	velocity.x = direction * SPEED
	if direction < 0:
		anim.flip_h = true
	elif anim.flip_h:
		anim.flip_h = false
		
	
	anim.play("default")

	move_and_slide()

func _below(character=null) -> void:
	pass
	
func _die(character=null) -> void:
	pass
	#queue_free()
	
func _cause_damage(character=null) -> void:
	character._take_damage()


func _on_hit_box_area_entered(area: Area2D) -> void:

	#if die:
		#return
		
	if area.name == "hitBox" and area.get_parent().name == "Player":
		_cause_damage(area.get_parent())
#
		## Определяем, с какой стороны произошло столкновение
		#if abs(direction.y) > abs(direction.x):  # Вертикальное столкновение
			#if direction.y > 0:  # Блок ниже
				#print("Блок задет снизу!")
				#_cause_damage(area.get_parent())
			#elif direction.y < 0:  # Блок выше
				#print("Блок задет сверху!")
				#_die(area.get_parent())
		#else:  # Горизонтальное столкновение
			#if direction.x > 0:  # Блок справа
				#print("Блок задет справа!")
				#_cause_damage(area.get_parent())
			#elif direction.x < 0:  # Блок слева
				#print("Блок задет слева!")
				#_cause_damage(area.get_parent())

	
		


func _on_eyes_body_entered(body: Node2D) -> void:
	pass
	#if body.is_in_group("block"):
		#direction = -direction
