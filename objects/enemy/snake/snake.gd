
extends BaseMoveEnemy

var direction = 1 
@onready var anim = $AnimatedSprite2D
var die = false

var previous_x_position: float
var stuck_timer: float = 0.0
const STUCK_THRESHOLD: float = 0.05  # Время, которое нужно провести в неподвижном состоянии, чтобы исчезнуть

func _ready():
	previous_x_position = position.x

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
		
	
	anim.play("move")

	move_and_slide()
	
	# Проверка застревания
	if abs(position.x - previous_x_position) < 0.1:  # Если положение почти не меняется
		stuck_timer += delta
		if stuck_timer >= STUCK_THRESHOLD:
			direction = direction * -1
	else:
		stuck_timer = 0.0  # Сброс таймера при движении

	# Обновление предыдущей позиции
	previous_x_position = position.x

func _below(character=null) -> void:
	pass
	
func _die(character=null) -> void:
	if character != null:
		character._on_jump()
	die = true
	anim.play("die")
	$CollisionShape2D.disabled = true
	#$left.disabled = true
	#$right.disabled = true
	#$bottom.disabled = true
	#$top.disabled = true
	
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
		direction = -direction


func _on_animated_sprite_2d_animation_finished() -> void:
	if die:
		queue_free()
