#include "sdk.h"

using namespace godot;

void FoxyAdventureSDK::_register_methods() {
    register_method("_process", &GDExample::_process);
}

FoxyAdventureSDK::FoxyAdventureSDK() {
}

FoxyAdventureSDK::~FoxyAdventureSDK() {
    // add your cleanup here
}

void FoxyAdventureSDK::_init() {
    // initialize any variables here
    time_passed = 0.0;
}

void FoxyAdventureSDK::_process(float delta) {
    time_passed += delta;

    Vector2 new_position = Vector2(10.0 + (10.0 * sin(time_passed * 2.0)), 10.0 + (10.0 * cos(time_passed * 1.5)));

    set_position(new_position);
}
