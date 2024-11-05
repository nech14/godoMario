extends CharacterBody2D

var character_parametrs: Character_parametrs

const SPEED = 300.0
const JUMP_VELOCITY = -600

var can_move = true
var spin_jumping = true

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta 
		

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
		velocity.y = self._jump_speed()

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
	character_parametrs = load("res://objects/character/character_parametrs.tres") as Character_parametrs
	
	add_to_group("player")


func _jump_speed():
	var base_speed: float = character_parametrs.base_jump_speed
	var speed_incr: float = character_parametrs.jump_speed_incr
	if spin_jumping:
		base_speed = character_parametrs.base_spin_jump_speed
		speed_incr = character_parametrs.spin_jump_speed_iner 
	return -(base_speed + speed_incr * int(abs(velocity.x) / 30))



# Добавьте этот метод для отключения движения
func stop_movement():
	can_move = false

# Добавьте этот метод для включения движения
func resume_movement():
	can_move = true
