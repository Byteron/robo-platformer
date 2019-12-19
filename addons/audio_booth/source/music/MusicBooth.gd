extends Node
class_name MusicBooth

enum PLAYMODES { PLAY, LOOP, SHUFFLE }

signal song_changed()

signal beat()
signal bar()

var play_song_on_beat_queue := []
var play_song_on_bar_queue := []

var play_track_on_beat_queue := []
var play_track_on_bar_queue := []

var stop_song_on_beat_queue := []
var stop_song_on_bar_queue := []

var stop_track_on_beat_queue := []
var stop_track_on_bar_queue := []

var current_song : Node = null

onready var songs := {}

func _ready() -> void:

	for song in get_children():
		song.connect("beat", self, "_on_beat")
		song.connect("bar", self, "_on_bar")
		songs[song.name] = song

func play_song(song_name: String, fade_time := 0.0) -> void:

	if is_song_playing(song_name):
		return

	if is_playing():
		stop_song(fade_time)

	current_song = _get_song(song_name)

	current_song.play_core(fade_time)
	current_song.set_process(true)

	emit_signal("song_changed")

func play_song_on_beat(song_name : String, fade_time := 0.0, delay := 0) -> void:
	play_song_on_beat_queue.append({ "song_name": song_name, "fade_time": fade_time, "delay": delay })

func play_song_on_bar(song_name : String, fade_time := 0.0, delay := 0) -> void:
	play_song_on_bar_queue.append({ "song_name": song_name, "fade_time": fade_time, "delay": delay })

func play_track(track: int, fade_time := 0.0) -> void:

	if not is_playing():
		return

	current_song.play_track(track, fade_time)

func play_track_on_beat(track: int, fade_time := 0.0, delay := 0) -> void:
	play_track_on_beat_queue.append({ "track": track, "fade_time": fade_time, "delay": delay })

func play_track_on_bar(track: int, fade_time := 0.0, delay := 0) -> void:
	play_track_on_bar_queue.append({ "track": track, "fade_time": fade_time, "delay": delay })

func stop_song(fade_time := 0.0) -> void:

	if not is_playing():
		return

	play_track_on_beat_queue = []
	stop_track_on_beat_queue = []

	play_track_on_bar_queue = []
	stop_track_on_bar_queue = []

	current_song.set_process(false)
	current_song.stop(fade_time)
	current_song = null

func stop_song_on_beat(fade_time := 0.0, delay := 0) -> void:
	stop_song_on_beat_queue.append({ "fade_time": fade_time, "delay": delay })

func stop_song_on_bar(fade_time := 0.0, delay := 0) -> void:
	stop_song_on_bar_queue.append({ "fade_time": fade_time, "delay": delay })

func stop_track(track: int, fade_time := 0.0) -> void:
#	print("Stop Track: ", track, ", Fade Out: ", fade_time)

	if not is_playing():
		return

	current_song.stop_track(track, fade_time)

func stop_track_on_beat(track: int, fade_time := 0.0, delay := 0) -> void:
	stop_track_on_beat_queue.append({ "track": track, "fade_time": fade_time, "delay": delay })

func stop_track_on_bar(track: int, fade_time := 0.0, delay := 0) -> void:
	stop_track_on_bar_queue.append({ "track": track, "fade_time": fade_time, "delay": delay })

func is_playing() -> bool:
	return current_song != null

func is_song_playing(song_name: String) -> bool:

	if not current_song:
		return false

	return current_song.name == song_name

func _get_song(song_name: String) -> Node:
	return songs[song_name]

func _iterate_container(container: Array, type: String, action: String) -> void:
	var done := []

	for data in container:

		if data.delay == 0:
			match type:
				"track":
					match action:
						"play": play_track(data.track, data.fade_time)
						"stop": stop_track(data.track, data.fade_time)
				"song":
					match action:
						"play": play_song(data.song_name, data.fade_time)
						"stop": stop_song(data.fade_time)

			done.append(data)
		else:
			data.delay -= 1

	for data in done:
		container.erase(data)

func _on_beat() -> void:

	_iterate_container(play_song_on_beat_queue, "song", "play")
	_iterate_container(stop_song_on_beat_queue, "song", "stop")

	_iterate_container(play_track_on_beat_queue, "track", "play")
	_iterate_container(stop_track_on_beat_queue, "track", "stop")

	emit_signal("beat")

func _on_bar() -> void:

	_iterate_container(play_song_on_bar_queue, "song", "play")
	_iterate_container(stop_song_on_bar_queue, "song", "stop")

	_iterate_container(play_track_on_bar_queue, "track", "play")
	_iterate_container(stop_track_on_bar_queue, "track", "stop")

	emit_signal("bar")
