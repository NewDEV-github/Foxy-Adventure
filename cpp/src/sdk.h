#ifndef FOXYADVENTURESDK_H
#define FOXYADVENTURESDK_H

#include <algorithm>
#include <array>
#include <string>
#include <vector>
#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <Godot.hpp>
#include <Node.hpp>
#include <OS.hpp>
#include <Engine.hpp>
// #include "reference.h"

namespace godot {

class FoxyAdventureSDK : public Node {
    GODOT_CLASS(FoxyAdventureSDK, Node)

private:
    template<typename T>
    std::string itos(T i);

    godot::String changelog = "Basic updates";
    godot::String version_string = "1.1.1";
    int version = 111
    float time_passed;
    bool initialized = false;
    bool debugger_initialized = false;
    godot::String dt = "FoxyAdventure.SDK";
    godot::String error_message = "[" + dt + ".Debugger] Error at: ";
    godot::String crash_message = "[" + dt + ".Debugger] Crash at: ";
    godot::String warning_message = "[" + dt + ".Debugger] Warning at: ";
    void init_debugger();
    void deinit_debugger();
    void throw_error(godot::String where, godot::String what);
    void throw_warning(godot::String where, godot::String what);
    void throw_crash(godot::String where, godot::String what);

public:
    const int INIT_FLAG_NORMAL = 0;
    const int INIT_FLAG_DEBUG = 1;
    static void _register_methods();

    FoxyAdventureSDK();
    ~FoxyAdventureSDK();

    void _init(); // our initializer called by Godot
    void init_sdk(int init_flag);
    void deinit_sdk();
    godot::String get_changelog();
    int get_version();
    godot::String get_version_string();

    void add_lives(int lives);
    void set_lives(int lives);
    godot::String get_lives();
    void remove_lives(int lives);

    void register_world(godot::String name, godot::String path);

    void add_coins(int lives);
    void set_coins(int lives);
    godot::String get_coins();
    void remove_coins(int lives);
    
    godot::String get_current_character_path();
    void set_current_character_path(godot::String path);

    void register_character(godot::String name, godot::String path);

    void add_hint_on_loading_screen(godot::String hint);

    void set_version_label_menu_bbcode_text(godot::String text);

    void add_custom_menu_bg(godot::String path);
    void add_custom_menu_audio(godot::String path);

    void change_stage(godot::String stage_id);
    void add_stage_to_list(godot::String stage_path, godot::String stage_name);
    void replace_stage_in_list(godot::String stage_id, godot::String stage_path, godot::String stage_name);
    void set_stage_list(godot::Dictionary list); //dictionary here
    void change_stage_to_next();
    void set_stage_name(godot::String stage_id, godot::String stage_name);
};

}

#endif
