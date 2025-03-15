class_name GameState extends Node

signal phase_changed(old_phase, new_phase)
signal player_turn_changed(new_player)

enum Phase { START, DRAW, MAIN, BATTLE, END }
enum PlayerType { PLAYER, OPPONENT }

var current_phase: Phase = Phase.END :
	set(value):
		var old = current_phase
		current_phase = value
		phase_changed.emit(old, current_phase)

var current_player: PlayerType = PlayerType.PLAYER :
	set(value):
		current_player = value
		player_turn_changed.emit(current_player)

var player_data: PlayerData
var opponent_data: PlayerData
var turn_number: int = 0

func reset():
	current_phase = Phase.END
	current_player = PlayerType.PLAYER
	turn_number = 0
