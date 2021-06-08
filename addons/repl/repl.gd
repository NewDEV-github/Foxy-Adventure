# GDScript REPL plugin
# Copyright (C) 2021  Sylvain Beucler

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

tool
extends EditorPlugin

var control

func _enter_tree():
	control = preload("res://addons/repl/repl_control.tscn").instance()
	# As a dock:
	#add_control_to_dock(DOCK_SLOT_RIGHT_BL, control)
	# In the bottom panel:
	add_control_to_bottom_panel(control, "REPL")

func _exit_tree():
	# As a dock:
	#remove_control_from_docks(control)
	# In the bottom panel:
	remove_control_from_bottom_panel(control)
	control.queue_free()
