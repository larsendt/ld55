extends CharacterBody2D

@export var walk_speed: float = 16.0

@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()


func _ready() -> void:
	_run_state()


func _run_state() -> void:
	while true:
		var direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
		velocity = direction * walk_speed
		await get_tree().create_timer(3.0).timeout


func _physics_process(_delta: float) -> void:
	if velocity.x < 0:
		$GhostSprite.play("Walking")
		$GhostSprite.flip_h = false
	elif velocity.x > 0:
		$GhostSprite.play("Walking")
		$GhostSprite.flip_h = true
	else:
		$GhostSprite.play("Walking")

	move_and_slide()
