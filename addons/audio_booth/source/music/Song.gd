extends Node
class_name Song

signal bar()
signal beat()

var pitch_scale := 1.0 setget _set_pitch_scale
var volume_db := 1.0 setget _set_volume_db

var time := 0.0

var beats_per_second := 0.0

var current_beat := 0
var last_beat := -1

# warning-ignore:unused_class_variable
var current_bar := 0

export var tempo := 0.0
export var beats := 0

onready var track_container := _get_track_container()
onready var stinger_containers := _get_stinger_containers()

onready var tracks : Array = track_container.get_tracks()
onready var core : AudioStreamPlayer = track_container.get_core()

onready var tween := Tween.new()

func _ready() -> void:
	set_process(false)

	beats_per_second = 60.0 / tempo

	for container in stinger_containers:
# warning-ignore:return_value_discarded
		connect(container.tick_type, container, "tick")

	tween.name = "Tween"
# warning-ignore:return_value_discarded
	tween.connect("tween_completed", self, "_on_Tween_tween_completed")
	add_child(tween)

# warning-ignore:unused_argument
func _process(delta: float) -> void:

	time = core.get_playback_position()

	current_beat = 1 + int(time / beats_per_second)

	if current_beat != last_beat:
		emit_signal("beat")

		if current_beat % beats == 0:
			emit_signal("bar")

		last_beat = current_beat

func play_core(fade_time := 0.0) -> void:

	if not has_core():
		return

	if fade_time:
		_fade_in(core, fade_time)

	core.play()

func play(fade_time := 0.0) -> void:

	for track_player in tracks:

		if fade_time:
			_fade_in(track_player, fade_time)

		track_player.play()

func stop(fade_time := 0.0) -> void:

	for track_player in tracks:

		if fade_time:
			_fade_out(track_player, fade_time)
		else:
			track_player.stop()

func play_track(track: int, fade_time := 0.0) -> void:

	if tracks.size() < track:
		return

	var track_player = tracks[track]

	if fade_time:
		_fade_in(track_player, fade_time)

	track_player.play()

func stop_track(track: int, fade_time := 0.0) -> void:
	var track_player = tracks[track]

	if fade_time:
		_fade_out(track_player, fade_time)
	else:
		track_player.stop()

func has_core() -> bool:
	return tracks.size() > 0

func _get_track_container() -> Node:

	for child in get_children():

		if child.type == "track":
			return child

	return null

func _get_stinger_containers() -> Array:
	var containers = []

	for child in get_children():

		if child.type == "stinger" and child.has_stinger():
			containers.append(child)

	return containers

func _set_pitch_scale(value) -> void:
	pitch_scale = value

	for track_player in tracks:
		track_player.pitch_scale = value

func _set_volume_db(value) -> void:
	volume_db = value

	for track_player in tracks:
		track_player.volume_db = value

func _fade_in(player: AudioStreamPlayer, fade_time: float) -> void:
	player.volume_db = -60
# warning-ignore:return_value_discarded
	tween.interpolate_property(player, "volume_db", -60.0, volume_db, fade_time, Tween.TRANS_QUINT, Tween.EASE_OUT)
# warning-ignore:return_value_discarded
	tween.start()

func _fade_out(player: AudioStreamPlayer, fade_time: float) -> void:
# warning-ignore:return_value_discarded
	tween.interpolate_property(player, "volume_db", volume_db, -60.0, fade_time, Tween.TRANS_QUINT, Tween.EASE_IN)
# warning-ignore:return_value_discarded
	tween.start()

# warning-ignore:unused_argument
func _on_Tween_tween_completed(object: Object, key: NodePath) -> void:

	if object is AudioStreamPlayer and object.volume_db == -60.0:
		object.stop()
