extends Node2D

func _on_seperation_slider_value_changed(value):
	Global.seperation_multiplier = value

func _on_alignment_slider_value_changed(value):
	Global.alignment_multiplier = value

func _on_cohesion_slider_value_changed(value):
	Global.cohesion_multiplier = value

func _on_view_distance_slider_value_changed(value):
	Global.view_distance = value
