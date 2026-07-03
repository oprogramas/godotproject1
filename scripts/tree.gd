extends StaticBody3D

func _ready() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = int(abs(global_position.x * 137.0 + global_position.z * 251.0))

	# Randomizar escala e rotação Y da árvore inteira
	var h := rng.randf_range(0.8, 1.5)
	var w := rng.randf_range(0.75, 1.2)
	scale = Vector3(w, h, w)
	rotation.y = rng.randf_range(0.0, TAU)

	# Deslocar cada cluster de copa ligeiramente
	for child in get_children():
		if child.name.begins_with("Cluster"):
			child.position += Vector3(
				rng.randf_range(-0.5, 0.5),
				rng.randf_range(-0.3, 0.3),
				rng.randf_range(-0.5, 0.5)
			)
