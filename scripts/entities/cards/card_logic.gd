class_name CardLogic extends RefCounted

# Signals for gameplay events
signal playability_changed(is_playable: bool)
signal card_played()

# Shared Properties
var card_data: CardData
var player: Player
var is_playable: bool = false :
	set(value):
		if is_playable != value:
			is_playable = value
			playability_changed.emit(value)

# Dependencies
var slot_manager: SlotManager:
	get: return player.slot_manager if player else null

var resource_component: ResourceComponent:
	get: return player.resource_component if player else null

func _init(data: CardData, player_ref: Player) -> void:
	card_data = data
	player = player_ref

func check_playability() -> void:
	var was_playable = is_playable
	var conditions = card_data.get_play_conditions()
	
	for condition in conditions:
		if not condition.validate(self):
			is_playable = false
			return
	
	is_playable = resource_component.can_afford(card_data.cost) && slot_manager.has_available_slot(card_data.type)
	
	if was_playable != is_playable:
		playability_changed.emit(is_playable)

func attempt_play() -> bool:
	if !is_playable:
		return false
	
	resource_component.spend(card_data.cost)
	card_played.emit()
	return true
