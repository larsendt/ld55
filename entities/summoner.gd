extends CharacterBody2D

const WALK_SPEED = 50.0
const SUMMON_WALK_SPEED = 25.0
const SUMMONING_TIME = 5.0

var summoning_progress = 0.0

@onready var Ghost: PackedScene = preload("res://entities/ghoooost.tscn")


func _ready() -> void:
	$PickupArea.area_entered.connect(self._do_pickup)


func _physics_process(delta: float) -> void:
	var summoning = false

	if Input.is_action_pressed("summon") && State.player_soul_tokens > 0:
		summoning = true

	var x = 0
	if Input.is_action_pressed("move_left"):
		x = -1
		$SummonerSprite.flip_h = false
	elif Input.is_action_pressed("move_right"):
		x = 1
		$SummonerSprite.flip_h = true

	var y = 0
	if Input.is_action_pressed("move_up"):
		y = -1
	elif Input.is_action_pressed("move_down"):
		y = 1

	if summoning:
		$SummonerSprite.play("Summoning")
	elif velocity.length() > 0:
		$SummonerSprite.play("Walking")
	else:
		$SummonerSprite.play("Idling")

	if summoning:
		summoning_progress += delta
	else:
		summoning_progress -= delta
	summoning_progress = clamp(summoning_progress, 0.0, SUMMONING_TIME)

	$ProgressBar.set_progress(summoning_progress / SUMMONING_TIME)

	if summoning_progress > 0 || summoning:
		$ProgressBar.visible = true
	else:
		$ProgressBar.visible = false

	if summoning_progress >= SUMMONING_TIME:
		var ghost = Ghost.instantiate()
		ghost.global_position = global_position + Vector2(-20.0, 0.0)
		get_parent().get_node("Minions").add_child(ghost)
		summoning_progress = 0.0
		State.player_soul_tokens -= 1

	var walk_speed = WALK_SPEED
	if summoning:
		walk_speed = SUMMON_WALK_SPEED

	velocity = Vector2(x, y) * walk_speed
	move_and_slide()


func _do_pickup(area: Area2D):
	State.player_soul_tokens += 1
	area.get_parent().queue_free()
