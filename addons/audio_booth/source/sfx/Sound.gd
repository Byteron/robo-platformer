extends Node
class_name Sound

var volume := 0.0 setget _set_volume

export var singleton := false

export(AudioStream) var stream = null
export(Array, AudioStream) var streams := []

export(float, -80, 24) var volume_db := 0.0 setget _set_volume_db
export(float, 0, 24) var randomize_volume_db := 0.0
export(float, 0.1, 32) var pitch_scale := 1.0
export(float, 0, 1) var randomize_pitch_scale := 0.0

onready var player : AudioStreamPlayer

func _ready() -> void:

	if singleton:
		player = _new_player()
		add_child(player)

func play() -> void:
	if singleton:
		_randomize(player)
		player.play()
	else:
		var new_player = _new_player()
		new_player.connect("finished", self, "_on_AudioStreamPlayer_finished", [ new_player ])
		add_child(new_player)
		_randomize(new_player)
		new_player.play()

func stop() -> void:
	if singleton:
		player.stop()

func _randomize(_player: AudioStreamPlayer) -> void:
	randomize()

	if randomize_volume_db:
		_player.volume_db = rand_range(volume_db - randomize_volume_db, volume_db + randomize_volume_db)

	if randomize_pitch_scale:
		_player.pitch_scale = rand_range(pitch_scale - randomize_pitch_scale, pitch_scale + randomize_pitch_scale)

	if streams:
		_player.stream = streams[randi() % streams.size()]

func _new_player() -> AudioStreamPlayer:
	var new_player = AudioStreamPlayer.new()
	new_player.name = "AudioStreamPlayer"
	new_player.stream = stream
	new_player.volume_db = volume_db
	new_player.pitch_scale = pitch_scale
	return new_player

func _set_volume(value: float) -> void:
	volume = value
	_set_volume_db(linear2db(value))

func _set_volume_db(value: float) -> void:
	volume_db = value
	if player:
		player.volume_db = value

func _on_AudioStreamPlayer_finished(_player: AudioStreamPlayer) -> void:
	_player.queue_free()
