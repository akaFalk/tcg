class_name CardData extends Resource

enum Type { CREATURE, SPELL, FIELD } # Card types

const TYPE_DISPLAY_STRING: Dictionary = {
	Type.CREATURE: "Creature",
	Type.SPELL: "Spell",
	Type.FIELD: "Field"
}

@export var name: String = ""
@export var cost: int = 0
@export var type: Type
@export var description: String = ""
@export var image: Texture2D = null

func get_type_as_string() -> String:
	return TYPE_DISPLAY_STRING[type]
