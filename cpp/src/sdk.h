#ifndef GDEXAMPLE_H
#define GDEXAMPLE_H

#include <Godot.hpp>
#include <Sprite.hpp>

namespace godot {

class FoxyAdventureSDK : public Sprite {
    GODOT_CLASS(FoxyAdventureSDK, Sprite)

private:
    float time_passed;

public:
    static void _register_methods();

    FoxyAdventureSDK();
    ~FoxyAdventureSDK();

    void _init(); // our initializer called by Godot

    void _process(float delta);
};

}
