extends Node3D

const TREE_SCENE := preload("res://scenes/tree.tscn")

const FOREST_AREA := 48.0
const MIN_DISTANCE := 2.8
const TOTAL_TREES := 150
const SEED := 12345

# Centros de zonas densas (clusters de floresta)
const DENSE_CLUSTERS := [
	Vector2(18, -22),
	Vector2(-20, 12),
	Vector2(28, 18),
	Vector2(-12, -28),
	Vector2(10, 30),
	Vector2(-30, -8),
]

# Clareiras — raio mínimo sem árvores
const CLEARINGS := [
	Vector2(0, 0),      # spawn do jogador
	Vector2(4, -3),     # item 1
	Vector2(-6, 2),     # item 2
	Vector2(7, 6),      # item 3
]
const CLEARING_RADIUS := 7.0
const ITEM_CLEARING_RADIUS := 4.0

func _ready() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = SEED

	var placed_positions: Array[Vector2] = []
	var placed := 0
	var attempts := 0

	while placed < TOTAL_TREES and attempts < TOTAL_TREES * 30:
		attempts += 1

		var pos: Vector2

		# 55% de chance de colocar num cluster denso
		if rng.randf() < 0.55:
			var cluster: Vector2 = DENSE_CLUSTERS[rng.randi() % DENSE_CLUSTERS.size()]
			pos = cluster + Vector2(
				rng.randf_range(-14.0, 14.0),
				rng.randf_range(-14.0, 14.0)
			)
		else:
			pos = Vector2(
				rng.randf_range(-FOREST_AREA, FOREST_AREA),
				rng.randf_range(-FOREST_AREA, FOREST_AREA)
			)

		# Verificar limites
		if abs(pos.x) > FOREST_AREA or abs(pos.y) > FOREST_AREA:
			continue

		# Verificar clareiras
		var blocked := false
		if pos.length() < CLEARING_RADIUS:
			blocked = true
		if not blocked:
			for i in range(1, CLEARINGS.size()):
				if pos.distance_to(CLEARINGS[i]) < ITEM_CLEARING_RADIUS:
					blocked = true
					break
		if blocked:
			continue

		# Verificar distância mínima entre árvores
		var too_close := false
		for existing in placed_positions:
			if pos.distance_to(existing) < MIN_DISTANCE:
				too_close = true
				break
		if too_close:
			continue

		# Colocar árvore
		placed_positions.append(pos)
		var tree := TREE_SCENE.instantiate()
		tree.position = Vector3(pos.x, 0.0, pos.y)
		add_child(tree)
		placed += 1

	print("[ForestGenerator] Árvores colocadas: ", placed)
