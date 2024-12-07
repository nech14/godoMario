extends CharacterBody2D

var character_parametrs: Character_parametrs

const SPEED = 300.0
const MAX_SPEED = 1000.0
const JUMP_VELOCITY = -600

var can_move = true
var spin_jumping = true
var p_meter: float = 0.0  # Текущий уровень P-метра
var is_running = false    # Переменная для состояния бега

@export var matHealth = 1
@onready var currentHealth = 1

func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta 
		
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = _jump_speed()
		
	if can_move:
		var direction := Input.get_axis("ui_left", "ui_right")
		
		if direction != 0:
			if Input.is_action_pressed("ui_sprint"):
				# Увеличиваем P-метр по мере удержания кнопки бега
				p_meter = min(p_meter + delta, character_parametrs.max_p_meter)
				is_running = p_meter >= character_parametrs.max_p_meter
			else:
				# Если кнопка бега не удерживается, P-метр уменьшается
				p_meter = max(p_meter - delta, 0)
				is_running = false

			# Определяем ускорение и максимальную скорость в зависимости от состояния бега
			var accel = character_parametrs.run_accel if is_running else character_parametrs.walk_accel
			var max_speed = character_parametrs.max_sprint_speed if is_running else character_parametrs.p_meter_starting_speed
			velocity.x = move_toward(velocity.x, direction * max_speed, accel * delta)
		else:
			# Замедляем игрока при отпускании направления
			var decel = character_parametrs.run_decel if is_running else character_parametrs.walk_decel
			velocity.x = move_toward(velocity.x, 0, decel * delta)
			p_meter = max(p_meter - delta, 0)

	else:
		velocity.x = 0
		p_meter = 0
	
	
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


func stop_movement():
	can_move = false


func resume_movement():
	can_move = true


func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.name == "hitBox":
		currentHealth -= 1
		if currentHealth <= 0:
			get_tree().change_scene_to_file("res://scenes/status_screens/dead_scean.tscn")
		
	pass # Replace with function body.
