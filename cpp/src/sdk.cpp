#include "sdk.h"
#include <algorithm>
#include <array>
#include <string>
#include <vector>
#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
using namespace godot;

void FoxyAdventureSDK::_register_methods() {
    register_method("init_sdk", &FoxyAdventureSDK::init_sdk);
    register_method("deinit_sdk", &FoxyAdventureSDK::deinit_sdk);
    register_method("get_changelog", &FoxyAdventureSDK::get_changelog);
    register_method("get_version", &FoxyAdventureSDK::get_version);
    register_method("get_version_string", &FoxyAdventureSDK::get_version_string);
    register_method("add_lives", &FoxyAdventureSDK::add_lives);
    register_method("get_lives", &FoxyAdventureSDK::get_lives);
    register_method("set_lives", &FoxyAdventureSDK::set_lives);
    register_method("remove_lives", &FoxyAdventureSDK::remove_lives);
    register_method("register_world", &FoxyAdventureSDK::register_world);
    register_method("add_coins", &FoxyAdventureSDK::add_coins);
    register_method("get_coins", &FoxyAdventureSDK::get_coins);
    register_method("set_coins", &FoxyAdventureSDK::set_coins);
    register_method("remove_coins", &FoxyAdventureSDK::remove_coins);
    register_method("get_current_character_path", &FoxyAdventureSDK::get_current_character_path);
    register_method("set_current_character_path", &FoxyAdventureSDK::set_current_character_path);
    register_method("register_character", &FoxyAdventureSDK::register_character);
    register_method("add_hint_on_loading_screen", &FoxyAdventureSDK::add_hint_on_loading_screen);
    register_method("set_version_label_menu_bbcode_text", &FoxyAdventureSDK::set_version_label_menu_bbcode_text);
    register_method("add_custom_menu_bg", &FoxyAdventureSDK::add_custom_menu_bg);
    register_method("add_custom_menu_audio", &FoxyAdventureSDK::add_custom_menu_audio);
    register_method("change_stage", &FoxyAdventureSDK::change_stage);
    register_method("add_stage_to_list", &FoxyAdventureSDK::add_stage_to_list);
    register_method("replace_stage_in_list", &FoxyAdventureSDK::replace_stage_in_list);
    register_method("set_stage_list", &FoxyAdventureSDK::set_stage_list);
    register_method("change_stage_to_next", &FoxyAdventureSDK::change_stage_to_next);
    register_method("set_stage_name", &FoxyAdventureSDK::set_stage_name);

}

template<typename T>
std::string FoxyAdventureSDK::itos(T i) {
    std::stringstream s;
    s << i;
    return s.str();
}

FoxyAdventureSDK::FoxyAdventureSDK() {

}
FoxyAdventureSDK::~FoxyAdventureSDK() {
    // add your cleanup here
}

void FoxyAdventureSDK::deinit_sdk() {
    godot::Godot::print("De-initializing Foxy Adventure SDK...");
    initialized = false;
    godot::Godot::print("Foxy Adventure SDK de-initialized!");
    if (debugger_initialized == true) {
        FoxyAdventureSDK::deinit_debugger();
    }
}

void FoxyAdventureSDK::deinit_debugger() {
    godot::Godot::print("De-initializing Foxy Adventure SDK Debugger...");
    debugger_initialized = false;
    godot::Godot::print("Foxy Adventure SDK Debugger de-initialized!");
}
void FoxyAdventureSDK::_init() {
    godot::String text_1 = "Loaded Foxy Adventure SDK, version: ";
    godot::String text_2 = ", ";
    godot::String godot_string_version = FoxyAdventureSDK::itos(version).c_str();
    godot::Godot::print(text_1 + godot_string_version + text_2 + version_string);
    initialized = false;
    debugger_initialized = false;
}

void FoxyAdventureSDK::init_sdk(int init_flag) {
    godot::Godot::print("Initializing Foxy Adventure SDK...");
    godot::Godot::print("Checking for SDK version support...");
    String f = OS::get_singleton()->get_user_data_dir();
    std::string f_std = FoxyAdventureSDK::itos(f.alloc_c_string()) + "/sdk_data";
    // std::cout << f_std << std::endl;
    std::ifstream inFile(f_std);
	if(!inFile)
	{
		godot::Godot::print("Can not initialize SDK - SDK Data file not found\nYou should try re-run the game to fix that :/");

	}
	std::string line;
  int size = 0;
  std::string versions [1];
	while(getline(inFile, line)){
        godot::String n = line.c_str();
        godot::String godot_string_version = FoxyAdventureSDK::itos(version).c_str();
        versions[size++] = line; // adding all supported versions to the array
        if (n == godot_string_version) {
            if (init_flag == 0) {
                initialized = true;
                godot::Godot::print("Foxy Adventure SDK Initialized!");
                break;
            }
            if (init_flag == 1) {
                initialized = true;
                godot::Godot::print("Foxy Adventure SDK Initialized!");
                FoxyAdventureSDK::init_debugger();
                break;
            }
        }
    }
    if (std::find(std::begin(versions), std::end(FoxyAdventureSDK::itos(version))) == std::end(versions))
    {
        godot::Godot::print("Sorry, but it seems like tkere is unsupported SDK version");
    }
}
void FoxyAdventureSDK::init_debugger() {
    godot::Godot::print("Initializing Foxy Adventure SDK Debugger...");
    debugger_initialized = true;
    godot::Godot::print("Foxy Adventure SDK Debugger Initialized!");
}
void FoxyAdventureSDK::throw_error(godot::String where, godot::String what) {
    if (initialized == true) {
        if (debugger_initialized == true) {
            godot::String com = " - ";
            godot::Godot::print(error_message + where + com + what);
        }
    }
    else {
        godot::Godot::print("SDK not initialized - function won't work");
    }
}
void FoxyAdventureSDK::throw_warning(godot::String where, godot::String what) {
    if (initialized == true) {
        if (debugger_initialized == true) {
            godot::String com = " - ";
            godot::Godot::print(warning_message + where + com + what);
        }
    }
    else {
        godot::Godot::print("SDK not initialized - function won't work");
    }
}
void FoxyAdventureSDK::throw_crash(godot::String where, godot::String what) {
    if (initialized == true) {
        if (debugger_initialized == true) {
            godot::String com = " - ";
            godot::Godot::print(crash_message + where + com + what);
        }
    }
    else {
        godot::Godot::print("SDK not initialized - function won't work");
    }
}
godot::String FoxyAdventureSDK::get_changelog() {
    return changelog;
}
int FoxyAdventureSDK::get_version() {
    return version;
}
godot::String FoxyAdventureSDK::get_version_string() {
    return version_string;
}
void FoxyAdventureSDK::add_lives(int lives) {
    if (initialized == true) {
        int current_lifes = get_node(NodePath("/root/Globals"))->get("lives");
        get_node(NodePath("/root/Globals"))->set("lives", (current_lifes += lives));
    }
    else {
        godot::Godot::print("SDK not initialized - function won't work");
    }
}
void FoxyAdventureSDK::set_lives(int lifes) {
    if (initialized == true) {
        godot::Array args{};
        args.push_back(lifes);
        get_node(NodePath("/root/Globals"))->call("set_lifes", lifes);
    }
    else {
        godot::Godot::print("SDK not initialized - function won't work");
    }

}
godot::String FoxyAdventureSDK::get_lives() {
    if (initialized == true) {
        return get_node(NodePath("/root/Globals"))->get("lives");
    }
    else {
        godot::Godot::print("SDK not initialized - function won't work");
    }

}
void FoxyAdventureSDK::remove_lives(int lives) {
    if (initialized == true) {
        int current_lifes = get_node(NodePath("/root/Globals"))->get("lives");
        get_node(NodePath("/root/Globals"))->set("lives", (current_lifes -= lives));
    }
    else {
        godot::Godot::print("SDK not initialized - function won't work");
    }
}
void FoxyAdventureSDK::register_world(godot::String name, godot::String path) {
    if (initialized == true) {
        godot::Array args{};
        args.push_back(name);
        args.push_back(path);
        get_node(NodePath("/root/Globals"))->call("add_world", args);
        godot::String txt1 = "Worlds";
        godot::String txt2 = "Registered world \"" + name + "\" at path: " + path;
        FoxyAdventureSDK::throw_warning(txt1, txt2);
    }
    else {
        godot::Godot::print("SDK not initialized - function won't work");
    }

}
void FoxyAdventureSDK::add_coins(int coins) {
    if (initialized == true) {
        godot::Array args{};
        args.push_back(coins);
        get_node(NodePath("/root/Globals"))->call("add_coin", args);
    }
    else {
        godot::Godot::print("SDK not initialized - function won't work");
    }

}
void FoxyAdventureSDK::set_coins(int coins) {
    if (initialized == true) {
        godot::Array args{};
        args.push_back(coins);
        get_node(NodePath("/root/Globals"))->call("set_coins", args);
    }
    else {
        godot::Godot::print("SDK not initialized - function won't work");
    }

}
godot::String FoxyAdventureSDK::get_coins() {
    if (initialized == true) {
        return get_node(NodePath("/root/Globals"))->get("coins");
    }
    else {
        godot::Godot::print("SDK not initialized - function won't work");
    }
}
void FoxyAdventureSDK::remove_coins(int coins) {
    if (initialized == true) {
        godot::Array args{};
        args.push_back(coins);
        get_node(NodePath("/root/Globals"))->call("remove_coins", args);
    }
    else {
        godot::Godot::print("SDK not initialized - function won't work");
    }

}
godot::String FoxyAdventureSDK::get_current_character_path() {
    if (initialized == true) {
        return get_node(NodePath("/root/Globals"))->get("character_path");
    }
    else {
        godot::Godot::print("SDK not initialized - function won't work");
    }

}
void FoxyAdventureSDK::set_current_character_path(godot::String path) {
    if (initialized == true) {
        godot::Array args{};
        args.push_back(path);
        get_node(NodePath("/root/Globals"))->set("character_path", args);
    }
    else {
        godot::Godot::print("SDK not initialized - function won't work");
    }

}
void FoxyAdventureSDK::register_character(godot::String name, godot::String path) {
    if (initialized == true) {
        godot::Array args{};
        args.push_back(name);
        args.push_back(path);
        get_node(NodePath("/root/Globals"))->call("add_character", args);
        godot::String txt1 = "Characters";
        godot::String txt2 = "Registered character \"" + name + "\" at path: " + path;
        FoxyAdventureSDK::throw_warning(txt1, txt2);
    }
    else {
        godot::Godot::print("SDK not initialized - function won't work");
    }
}
void FoxyAdventureSDK::add_hint_on_loading_screen(godot::String hint) {
    if (initialized == true) {
        godot::Array args{};
        args.push_back(hint);
        get_node(NodePath("/root/BackgroundLoad/bgload"))->call("add_hint", args);
    }
    else {
        godot::Godot::print("SDK not initialized - function won't work");
    }

}
void FoxyAdventureSDK::set_version_label_menu_bbcode_text(godot::String text) {
    if (initialized == true) {
        godot::Array args{};
        args.push_back(text);
        get_node(NodePath("/root/Globals"))->set("game_version_text", args);
        get_node(NodePath("/root/Globals"))->call("construct_game_version");
    }
    else {
        godot::Godot::print("SDK not initialized - function won't work");
    }

}
void FoxyAdventureSDK::add_custom_menu_bg(godot::String path)  {
    if (initialized == true) {
        godot::Array args{};
        args.push_back(path);
        get_node(NodePath("/root/Globals"))->set("custom_menu_bg", args);
    }
    else {
        godot::Godot::print("SDK not initialized - function won't work");
    }
}
void FoxyAdventureSDK::add_custom_menu_audio(godot::String path) {
    if (initialized == true) {
        godot::Array args{};
        args.push_back(path);
        get_node(NodePath("/root/Globals"))->set("custom_menu_audio", args);
    }
    else {
        godot::Godot::print("SDK not initialized - function won't work");
    }
}
void FoxyAdventureSDK::change_stage(godot::String stage_id) {
    if (initialized == true) {
        godot::Array args{};
        args.push_back(stage_id);
        get_node(NodePath("/root/Globals"))->call("change_stage", args);
    }
    else {
        godot::Godot::print("SDK not initialized - function won't work");
    }

}
void FoxyAdventureSDK::add_stage_to_list(godot::String stage_path, godot::String stage_name) {
    if (initialized == true) {
        godot::Array args{};
        args.push_back(stage_path);
        args.push_back(stage_name);
        get_node(NodePath("/root/Globals"))->call("add_stage_to_list", args);
    }
    else {
        godot::Godot::print("SDK not initialized - function won't work");
    }

}
void FoxyAdventureSDK::replace_stage_in_list(godot::String stage_id, godot::String stage_path, godot::String stage_name) {
    if (initialized == true) {
        godot::Array args{};
        args.push_back(stage_id);
        args.push_back(stage_path);
        args.push_back(stage_name);
        get_node(NodePath("/root/Globals"))->call("replace_stage_in_list", args);
    }
    else {
        godot::Godot::print("SDK not initialized - function won't work");
    }
}
void FoxyAdventureSDK::set_stage_list(godot::Dictionary list) {
    if (initialized == true) {
        godot::Array args{};
        args.push_back(list);
        get_node(NodePath("/root/Globals"))->call("set_stage_list", args);
    }
    else {
        godot::Godot::print("SDK not initialized - function won't work");
    }
}
void FoxyAdventureSDK::change_stage_to_next() {
    if (initialized == true) {
        get_node(NodePath("/root/Globals"))->call("change_stage_to_next");
    }
    else {
        godot::Godot::print("SDK not initialized - function won't work");
    }
}
void FoxyAdventureSDK::set_stage_name(godot::String stage_id, godot::String stage_name) {
    if (initialized == true) {
        godot::Array args{};
        args.push_back(stage_id);
        args.push_back(stage_name);
        get_node(NodePath("/root/Globals"))->call("set_stage_name", args);
    }
    else {
        godot::Godot::print("SDK not initialized - function won't work");
    }
}
