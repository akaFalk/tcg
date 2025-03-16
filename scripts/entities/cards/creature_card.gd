class_name CreatureCard extends Card

@export var attack_health_label: Label3D

func _ready() -> void:
	#super._ready()
	attack_health_label.text = str(logic.card_data.attack) + "/" + str(logic.card_data.health)

func play() -> void:
	logic.attempt_play()
	print("Summoning Creature: %s" % logic.card_data.name)
	# Creature-specific logic here
