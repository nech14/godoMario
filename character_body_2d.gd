extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -600.0

var can_move = true

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta 

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if can_move:
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		# Если игрок не может двигаться, обнуляем его скорость
		velocity.x = 0
	

	move_and_slide()
	
	
func _ready() -> void:
	add_to_group("player")


# Добавьте этот метод для отключения движения
func stop_movement():
	can_move = false

# Добавьте этот метод для включения движения
func resume_movement():
	can_move = true
