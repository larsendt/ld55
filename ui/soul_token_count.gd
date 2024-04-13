extends Label


func _ready() -> void:
	State.soul_tokens_updated.connect(self._soul_tokens_updated)


func _soul_tokens_updated(tokens: int) -> void:
	self.text = str(tokens)
