#include "sdk.h"

using namespace godot;

void FoxyAdventureSDK::_register_methods() {
    register_method("init_sdk", &FoxyAdventureSDK::init_sdk);
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

FoxyAdventureSDK::FoxyAdventureSDK() {

}

FoxyAdventureSDK::~FoxyAdventureSDK() {
    // add your cleanup here
}
void FoxyAdventureSDK::_init() {
    initialized = false;
    debugger_initialized = false;
}
void FoxyAdventureSDK::init_sdk(int init_flag) {
    godot::Godot::print("Initializing Foxy Adventure SDK...");
    if (init_flag == 0) {
        initialized = true;
        godot::Godot::print("Foxy Adventure SDK Initialized!");
    }
    if (init_flag == 1) {
        initialized = true;
        godot::Godot::print("Foxy Adventure SDK Initialized!");
        FoxyAdventureSDK::init_debugger();
    }
}

void FoxyAdventureSDK::init_debugger() {
    godot::Godot::print("Initializing Foxy Adventure SDK Debugger...");
    debugger_initialized = true;
     godot::Godot::print("Foxy Adventure SDK Debugger Initialized!");
}
void FoxyAdventureSDK::get_changelog() {

}
void FoxyAdventureSDK::get_version() {

}
void FoxyAdventureSDK::get_version_string() {

}
void FoxyAdventureSDK::add_lives(int lives) {
    int current_lifes = get_node("/root/Globals")->get("lives");
    get_node("/root/Globals")->set("lives", (current_lifes += lives));
}
void FoxyAdventureSDK::set_lives(int lifes) {
    godot::Array args{};
    args.push_back(lifes);
    get_node("/root/Globals")->call("set_lifes", lifes);

}
godot::String FoxyAdventureSDK::get_lives() {
    return get_node("/root/Globals")->get("lives");

}
void FoxyAdventureSDK::remove_lives(int lives) {
    int current_lifes = get_node("/root/Globals")->get("lives");
    get_node("/root/Globals")->set("lives", (current_lifes -= lives));
}
void FoxyAdventureSDK::register_world(godot::String name, godot::String path) {
    godot::Array args{};
    args.push_back(name);
    args.push_back(path);
    get_node("/root/Globals")->call("add_world", args);

}
void FoxyAdventureSDK::add_coins(int coins) {
    godot::Array args{};
    args.push_back(coins);
    get_node("/root/Globals")->call("add_coin", args);

}
void FoxyAdventureSDK::set_coins(int coins) {
    godot::Array args{};
    args.push_back(coins);
    get_node("/root/Globals")->call("set_coins", args);

}
godot::String FoxyAdventureSDK::get_coins() {
    return get_node("root/Globals")->get("coins");
}
void FoxyAdventureSDK::remove_coins(int coins) {
    godot::Array args{};
    args.push_back(coins);
    get_node("/root/Globals")->call("remove_coins", args);

}
godot::String FoxyAdventureSDK::get_current_character_path() {
    return get_node("/root/Globals")->get("character_path");

}
void FoxyAdventureSDK::set_current_character_path(godot::String path) {
    godot::Array args{};
    args.push_back(path);
    get_node("/root/Globals")->set("character_path", args);

}
void FoxyAdventureSDK::register_character(godot::String name, godot::String path) {
    godot::Array args{};
    args.push_back(name);
    args.push_back(path);
    get_node("/root/Globals")->call("add_character", args);
}
void FoxyAdventureSDK::add_hint_on_loading_screen(godot::String hint) {
    godot::Array args{};
    args.push_back(hint);
    get_node("/root/BackgroundLoad/bgload")->call("add_hint", args);

}
void FoxyAdventureSDK::set_version_label_menu_bbcode_text(godot::String text) {
    godot::Array args{};
    args.push_back(text);
    get_node("/root/Globals")->set("game_version_text", args);
    get_node("/root/Globals")->call("construct_game_version");

}
void FoxyAdventureSDK::add_custom_menu_bg(godot::String path)  {
    godot::Array args{};
    args.push_back(path);
    get_node("/root/Globals")->set("custom_menu_bg", args);
}
void FoxyAdventureSDK::add_custom_menu_audio(godot::String path) {
    godot::Array args{};
    args.push_back(path);
    get_node("/root/Globals")->set("custom_menu_audio", args);
}
void FoxyAdventureSDK::change_stage(godot::String stage_id) {
    godot::Array args{};
    args.push_back(stage_id);
    get_node("/root/Globals")->call("change_stage", args);

}
void FoxyAdventureSDK::add_stage_to_list(godot::String stage_path, godot::String stage_name) {
    godot::Array args{};
    args.push_back(stage_path);
    args.push_back(stage_name);
    get_node("/root/Globals")->call("add_stage_to_list", args);

}
void FoxyAdventureSDK::replace_stage_in_list(godot::String stage_id, godot::String stage_path, godot::String stage_name) {
    godot::Array args{};
    args.push_back(stage_id);
    args.push_back(stage_path);
    args.push_back(stage_name);
    get_node("/root/Globals")->call("replace_stage_in_list", args);
}
void FoxyAdventureSDK::set_stage_list(godot::Dictionary list) {
    godot::Array args{};
    args.push_back(list);
    get_node("/root/Globals")->call("set_stage_list", args);
}
void FoxyAdventureSDK::change_stage_to_next() {
    get_node("/root/Globals")->call("change_stage_to_next");
}
void FoxyAdventureSDK::set_stage_name(godot::String stage_id, godot::String stage_name) {
    godot::Array args{};
    args.push_back(stage_id);
    args.push_back(stage_name);
    get_node("/root/Globals")->call("set_stage_name", args);
}