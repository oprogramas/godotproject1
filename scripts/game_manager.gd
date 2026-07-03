extends Node

var total_items: int = 0
var collected_items: int = 0

func _ready() -> void:
	# Conta todos os itens na cena ao iniciar
	await get_tree().process_frame
	total_items = get_tree().get_nodes_in_group("item").size()
	print("[GameManager] Total de itens: ", total_items)

func collect_item(item_name: String) -> void:
	collected_items += 1
	print("[GameManager] Coletou: ", item_name, " (", collected_items, "/", total_items, ")")
	if collected_items >= total_items and total_items > 0:
		_on_all_items_collected()

func _on_all_items_collected() -> void:
	print("[GameManager] Todos os itens encontrados!")
	# TODO: mostrar ecrã de vitória / próximo nível
