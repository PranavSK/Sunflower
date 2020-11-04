extends CenterContainer

onready var progress_bar: = $ProgressBar

func update_progress(progress: float, remap: = false):
	if remap:
		# prgress assumed in [0,1] if remap is true
		progress_bar.value = progress_bar.min_value + (progress * (progress_bar.max_value - progress_bar.min_value))
	else:
		progress_bar.value = progress
