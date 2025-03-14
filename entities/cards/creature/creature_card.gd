class_name CreatureCard extends Card

@export var attack_health_label: Label3D

var attack: int
var health: int

func set_card_data(data: CardData) -> void:
	super(data)
	attack = data.attack
	health = data.health
	attack_health_label.text = str(attack) + "/" + str(health)
	
func update_card_render(priority: int) -> void:
	super(priority)
	attack_health_label.render_priority = priority + 1

func set_labels_visible(show_labels: bool) -> void:
	super(show_labels)
	attack_health_label.visible = show_labels

# The creature card class implements creature-specific behavior.
func play() -> void:
	print("Summoning Creature: " + card_data.name +
		  " [Power: " + str(card_data.attack) +
		  ", Toughness: " + str(card_data.health) + "]")
	# TODO: Insert additional creature-specific logic (e.g., placing on the battlefield) here.
