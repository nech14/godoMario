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

var sprite_small: ColorRect
var sprite_big: ColorRect
var sprite_sitting: ColorRect
var sprite: ColorRect

var blocOnTop = false

var ducking: bool = false:
	set(value):
		var old_value: bool = ducking
		ducking = value
		if old_value != value:
			_updat_poweru_state_settings()

enum PowerupState{
	SMALL,
	BIG,
	CAPE,
	FIRE
}

var powerup_state: PowerupState = PowerupState.SMALL:
	set(value):
		powerup_state = value
		_updat_poweru_state_settings()

func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta 
		
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and !ducking:
		_on_jump()
		
	if Input.is_action_pressed("ui_down") and is_on_floor():  # Проверяем, нажата ли клавиша "вниз"
		ducking = true
		
	elif ducking and !blocOnTop:
		ducking = false
		
	if can_move:
		var direction := Input.get_axis("ui_left", "ui_right")
		
		if direction != 0:
			if Input.is_action_pressed("ui_sprint") and !ducking:
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


func _on_jump():
	velocity.y = _jump_speed()
	

func _take_damage(damage=1):
	if powerup_state != PowerupState.SMALL:
		powerup_state = PowerupState.SMALL
	else:
		currentHealth -= damage
		if currentHealth <= 0:
			get_tree().change_scene_to_file("res://scenes/status_screens/dead_scean.tscn")
	
	
func _ready() -> void:
	character_parametrs = load("res://objects/character/character_parametrs.tres") as Character_parametrs
	
	add_to_group("player")
	
	sprite_small = $ColorRect
	sprite_big = $BigCharacter
	sprite_sitting = $BigCharacterSitting
	
	_updat_poweru_state_settings()
	
	


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
		_take_damage()

		
	pass # Replace with function body.
	
	

func _small():
	return powerup_state == PowerupState.SMALL

	
func _updat_poweru_state_settings() -> void:
	
	var should_use_small_sprite: bool = _small()
	sprite_small.set_deferred("visible", should_use_small_sprite)
	sprite_big.set_deferred("visible", !should_use_small_sprite)
	sprite_sitting.set_deferred("visible", false)
	sprite = sprite_small if _small() else sprite_big
	
	if ducking:
		sprite.set_deferred("visible", false)
		sprite = sprite_sitting
		sprite.set_deferred("visible", true)
	
	
	var should_use_small_hitbox: bool = _small() or ducking
	var small_collision_shapes: Array = get_tree().get_nodes_in_group("player_hitbox_small")
	var big_collision_shape: Array = get_tree().get_nodes_in_group("player_hitbox_big")
	var collision_shapes: Array = small_collision_shapes + big_collision_shape
	for shape in collision_shapes:
		var should_activate: bool = (
			(should_use_small_hitbox and shape.is_in_group("player_hitbox_small")
			or (not should_use_small_hitbox and shape.is_in_group("player_hitbox_big")))
			)
		shape.set_deferred("disabled", !should_activate)
		
	


func _on_block_on_top_body_entered(body: Node2D) -> void:
	if ducking and powerup_state != PowerupState.SMALL and body.is_in_group("block"):
		ducking = true
		blocOnTop = true
	

func _on_block_on_top_body_exited(body: Node2D) -> void:
	if ducking and powerup_state != PowerupState.SMALL and body.is_in_group("block"):
		blocOnTop = false
		ducking = false
