extends Node

signal soul_tokens_updated(tokens: int)

var player_soul_tokens: int = 4:
	set(t):
		player_soul_tokens = t
		soul_tokens_updated.emit(t)
