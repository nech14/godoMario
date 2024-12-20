extends CharacterBody2D

class_name Player

var character_parametrs: Character_parametrs

const SPEED = 300.0
const MAX_SPEED = 1000.0
const JUMP_VELOCITY = -600
const BIG_JUMP_VELOCITY = -800
var jump_velocity = JUMP_VELOCITY

var can_move = true
var spin_jumping = true
var p_meter: float = 0.0  # Текущий уровень P-метра
var is_running = false    # Переменная для состояния бега

@export var matHealth = 1
@onready var currentHealth = 1

var sprite_small: AnimatedSprite2D
var sprite_big: AnimatedSprite2D
var sprite_sitting: AnimatedSprite2D
var sprite: AnimatedSprite2D
@export var fireball_scene: PackedScene
 
var blocOnTop = false

@onready var anim = $SmallAnimation
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D

var can_gunning = false

var gunning = false
var die = false
var is_blinking = false

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
	if die:
		return
	
	if can_gunning and Input.is_action_just_pressed("shotting"):
		var fireball = fireball_scene.instantiate()
		fireball.duration = int(anim.flip_h) * -2 + 1
		anim.play("gunning")
		gunning = true
		can_move = false
		var padding_for_big_form = int(powerup_state == PowerupState.BIG) * 10
		if anim.flip_h:
			fireball.position = position + Vector2(-15-padding_for_big_form, 0)
		else:
			fireball.position = position + Vector2(30+padding_for_big_form, 0)
			
		add_sibling(fireball)
		
	if not is_on_floor():
		velocity += get_gravity() * delta 
		
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and !ducking:
		_on_jump()
	elif is_on_floor() and velocity.y == 0:
		$hitBox.position.y = 0
		
	if powerup_state != PowerupState.SMALL and Input.is_action_pressed("ui_down") and is_on_floor():  # Проверяем, нажата ли клавиша "вниз"
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
				if velocity.y == 0 :
					anim.play("run")
					steps(direction)
			else:
				# Если кнопка бега не удерживается, P-метр уменьшается
				p_meter = max(p_meter - delta, 0)
				is_running = false
				if velocity.y == 0:
					if ducking:
						anim.play("steal")
					else:
						anim.play("move")
				
			if direction < 0:
				anim.flip_h = true
			elif anim.flip_h:
				anim.flip_h = false

			# Определяем ускорение и максимальную скорость в зависимости от состояния бега
			var accel = character_parametrs.run_accel if is_running else character_parametrs.walk_accel
			var max_speed = character_parametrs.max_sprint_speed if is_running else character_parametrs.p_meter_starting_speed
			velocity.x = move_toward(velocity.x, direction * max_speed, accel * delta)
		else:
			# Замедляем игрока при отпускании направления
			var decel = character_parametrs.run_decel if is_running else character_parametrs.walk_decel
			velocity.x = move_toward(velocity.x, 0, decel * delta)
			p_meter = max(p_meter - delta, 0)			
			if velocity.y == 0:
				if ducking:
					anim.play("sit")
				else:
					anim.play("stay")

	else:
		velocity.x = 0
		p_meter = 0
		if !gunning:
			anim.play("stay")
	
	
	move_and_slide()



func _on_jump():
	velocity.y = _jump_speed()
	$hitBox.position.y -= 7
	anim.play("jump")
	

func _take_damage(damage=1):
	if is_blinking:
		return 
	
	if powerup_state != PowerupState.SMALL:
		powerup_state = PowerupState.SMALL
		start_blinking()
	elif can_gunning:
		can_gunning = false
		start_blinking()
	else:
		currentHealth -= damage
		start_blinking()
		if currentHealth <= 0:
			can_move = false
			die = true
			anim.play("die")
	
	
func _ready() -> void:
	character_parametrs = load("res://objects/character/character_parametrs.tres") as Character_parametrs
	
	add_to_group("player")
	
	sprite_small = $SmallAnimation
	sprite_big = $BigAnimation
	
	_updat_poweru_state_settings()
	
	


func _jump_speed():
	var base_speed: float = character_parametrs.base_jump_speed
	var speed_incr: float = character_parametrs.jump_speed_incr * (1 + int(powerup_state == PowerupState.BIG))
	if spin_jumping:
		base_speed = character_parametrs.base_spin_jump_speed
		speed_incr = character_parametrs.spin_jump_speed_iner * (1 + int(powerup_state == PowerupState.BIG))
	return -(base_speed + speed_incr * int(abs(velocity.x) / 30))


func stop_movement():
	can_move = false


func resume_movement():
	can_move = true


func _on_hit_box_area_entered(area: Area2D) -> void:
	pass
	#if area.name == "hitBox":
		#_take_damage()

		
	pass # Replace with function body.
	
	

func _small():
	return powerup_state == PowerupState.SMALL

	
func _updat_poweru_state_settings() -> void:
	
	var should_use_small_sprite: bool = _small()
	sprite_small.set_deferred("visible", should_use_small_sprite)
	sprite_big.set_deferred("visible", !should_use_small_sprite)
	#sprite_sitting.set_deferred("visible", false)
	sprite = sprite_small if _small() else sprite_big
	
	#if ducking:
		#sprite.set_deferred("visible", false)
		#sprite = sprite_sitting
		#sprite.set_deferred("visible", true)
	#
	
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
	
	anim = sprite
	


func _on_block_on_top_body_entered(body: Node2D) -> void:
	if ducking and powerup_state != PowerupState.SMALL and body.is_in_group("block"):
		ducking = true
		blocOnTop = true
	

func _on_block_on_top_body_exited(body: Node2D) -> void:
	if ducking and powerup_state != PowerupState.SMALL and body.is_in_group("block"):
		blocOnTop = false
		ducking = false


func _on_small_animation_animation_finished() -> void:	
	gunning = false
	can_move = true
	if die:
		get_tree().change_scene_to_file("res://scenes/status_screens/dead_scean.tscn")
		
		
func steps(duration=1):
	gpu_particles_2d.emitting = true
	gpu_particles_2d.one_shot = true
	gpu_particles_2d.position.x = 20 - 10*duration
	


func start_blinking(duration = 2.0, blink_rate = 0.1):
	if not is_blinking:
		is_blinking = true
		var blink_timer = Timer.new()
		blink_timer.wait_time = blink_rate
		blink_timer.autostart = true
		blink_timer.one_shot = false
		blink_timer.connect("timeout", Callable(self, "_on_blink_timer_timeout"))
		add_child(blink_timer)
		
		await get_tree().create_timer(duration).timeout
		blink_timer.queue_free()
		sprite.modulate = Color(1, 1, 1, 1)  # Возвращаем обычный цвет
		is_blinking = false

func _on_blink_timer_timeout():
	sprite.modulate = Color(1, 0, 0, 1) if sprite.modulate == Color(1, 1, 1, 1) else Color(1, 1, 1, 1)
