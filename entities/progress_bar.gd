extends Node2D

const FRAME_COUNT = 22


func set_progress(p: float) -> void:
	p = clampf(p, 0.0, 1.0)
	$Sprite.frame = int(FRAME_COUNT * p)
