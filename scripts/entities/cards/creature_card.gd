class_name CreatureCard extends CardView

@export var attack_health_label: Label3D

func initialize_view(model: CardModel) -> void:
	super.initialize_view(model)
	attack_health_label.text = str(model.data.attack) + "/" + str(model.data.health)
	attack_health_label.visible = false
