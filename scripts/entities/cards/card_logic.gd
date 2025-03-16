class_name CardLogic extends RefCounted

# Signals for gameplay events
signal playability_changed(is_playable: bool)

# Shared Properties
var model: CardModel
var is_playable: bool = false :
	set(value):
		if is_playable != value:
			is_playable = value
			playability_changed.emit(value)

# Dependencies
var slot_manager: SlotManager:
	get: return model.owner.slot_manager

var resource_component: ResourceComponent:
	get: return model.owner.resource_component

func _init(model_ref: CardModel) -> void:
	model = model_ref

func check_playability() -> void:
	var was_playable = is_playable
	var conditions = model.data.get_play_conditions()
	
	for condition in conditions:
		if not condition.validate(model):
			is_playable = false
			return
	
	is_playable = resource_component.can_afford(model.data.cost) && slot_manager.has_available_slot(model.data.type)
	
	if was_playable != is_playable:
		playability_changed.emit(is_playable)

func attempt_play() -> bool:
	if !is_playable:
		return false
	
	resource_component.spend(model.data.cost)
	return true
