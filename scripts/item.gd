extends Area3D

@export var item_name: String = "Item Misterioso"

signal collected(item_name: String)

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		collect()

func collect() -> void:
	collected.emit(item_name)
	GameManager.collect_item(item_name)
	queue_free()
