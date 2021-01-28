extends Node
onready var webhook_err = load("res://bin/webhook_err/webhook_err.gdns").new()
onready var webhook_feedback = load("res://bin/webhook_feedback/webhook_feedback.gdns").new()
onready var website_faq = load("res://bin/website_faq/website_faq.gdns").new()
onready var website_gallery = load("res://bin/website_gallery/website_gallery.gdns").new()
onready var website_main = load("res://bin/website_main/website_main.gdns").new()
onready var website_dl = load("res://bin/website_dl/website_dl.gdns").new()
onready var website_privacy_policy = load("res://bin/website_privacy_policy/website_privacy_policy.gdns").new()
onready var website_project = load("res://bin/website_project/website_project.gdns").new()
#func _ready() -> void:
#	print(str(webhook_err.get_data()))
