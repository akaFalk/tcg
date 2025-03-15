class_name CreatureCard extends Card

@export var attack_health_label: Label3D

var attack: int
var health: int

func initialize(data: CardData) -> void:
	super(data)
	attack = data.attack
	health = data.health
	attack_health_label.text = str(attack) + "/" + str(health)

# The creature card class implements creature-specific behavior.
func play() -> void:
	print("Summoning Creature: " + card_data.name +
		  " [Power: " + str(card_data.attack) +
		  ", Toughness: " + str(card_data.health) + "]")
	# TODO: Insert additional creature-specific logic (e.g., placing on the battlefield) here.
