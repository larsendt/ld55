extends CharacterBody2D

enum CreatureState {
	DOWN,
	STANDING_UP,
	FALLING_DOWN,
	WALKING,
	IDLING,
}

@export var walk_speed: float = 12.0

var creature_state: CreatureState = CreatureState.DOWN

@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()


func _ready() -> void:
	_run_state()


func _run_state() -> void:
	while true:
		await _run_single_state()


func _run_single_state() -> void:
	velocity = Vector2.ZERO
	$RockCreatureSprite.play("Idling")
	await get_tree().create_timer(2.0).timeout

	$RockCreatureSprite.play("StandingUp")
	await $RockCreatureSprite.animation_finished

	$RockCreatureSprite.play("Walking")
	var direction = Vector2(rng.randf_range(-1.0, 1.0), rng.randf_range(-1.0, 1.0)).normalized()
	velocity = direction * walk_speed
	await get_tree().create_timer(5.0).timeout

	velocity = Vector2.ZERO
	$RockCreatureSprite.play("StandingUp", -1.0, true)
	await $RockCreatureSprite.animation_finished


func _physics_process(_delta: float) -> void:
	if velocity.x < 0:
		$RockCreatureSprite.flip_h = false
	elif velocity.x > 0:
		$RockCreatureSprite.flip_h = true

	move_and_slide()
