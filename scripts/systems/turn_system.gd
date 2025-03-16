class_name TurnSystem extends Node3D

# Define turn phases.
enum Phase {
	START,
	DRAW,
	MAIN,
	BATTLE,
	END
}

signal phase_changed(new_phase: Phase)
signal turn_started(player_id: String)
signal turn_ended(player_id: String)

@export var stack: Stack

@export var starting_player: Player.Type = Player.Type.PLAYER
@export var initial_phase_durations := {
	Phase.START: 0.5,
	Phase.DRAW: 1.0,
	Phase.MAIN: 7.0,
	Phase.BATTLE: 1.0,
	Phase.END: 0.5
}

var current_phase: Phase = Phase.END
var current_player: Player.Type
var is_first_turn: bool = true
var phase_timer: Timer

func _ready() -> void:
	phase_timer = Timer.new()
	add_child(phase_timer)
	phase_timer.timeout.connect(_advance_phase)
	current_player = starting_player
	set_phase(Phase.START)

func start_new_turn() -> void:
	current_player = _get_next_player()
	is_first_turn = false
	turn_started.emit(current_player)
	set_phase(Phase.START)

func set_phase(new_phase: Phase) -> void:
	current_phase = new_phase
	phase_changed.emit(current_phase)
	
	match current_phase:
		Phase.START:
			_handle_start_phase()
		Phase.DRAW:
			_handle_draw_phase()
		Phase.MAIN:
			_handle_main_phase()
		Phase.BATTLE:
			_handle_battle_phase()
		Phase.END:
			_handle_end_phase()

func _advance_phase() -> void:
	var next_phase = _get_next_phase()
	if next_phase == Phase.END:
		set_phase(next_phase)
	else:
		set_phase(next_phase)
		_start_phase_timer()

func _get_next_phase() -> Phase:
	match current_phase:
		Phase.START: return Phase.DRAW if _not_first_turn() else Phase.MAIN
		Phase.DRAW: return Phase.MAIN
		Phase.MAIN: return Phase.BATTLE if _not_first_turn() else Phase.END
		Phase.BATTLE: return Phase.END
		Phase.END: return Phase.START
	return Phase.END

func _not_first_turn() -> bool:
	return not is_first_turn

func _handle_start_phase() -> void:
	# Resource increment logic
	var player = _get_current_player_data()
	player.resource_component.increase_max()
	player.resource_component.refresh()
	
	_start_phase_timer()

func _handle_draw_phase() -> void:
	# Draw card logic will be connected via signal
	_start_phase_timer()

func _handle_main_phase() -> void:
	# Player input enabled here
	_start_phase_timer()

func _handle_battle_phase() -> void:
	# Battle logic placeholder
	_start_phase_timer()

func _handle_end_phase() -> void:
	turn_ended.emit(current_player)
	start_new_turn()

func _start_phase_timer() -> void:
	var duration = initial_phase_durations.get(current_phase, 1.0)
	phase_timer.start(duration)

func _get_current_player_data() -> Player:
	return GameManager.player if current_player == Player.Type.PLAYER else GameManager.opponent

func _get_next_player() -> Player.Type:
	return Player.Type.PLAYER if current_player == Player.Type.OPPONENT else Player.Type.OPPONENT
