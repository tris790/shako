const std = @import("std");
const c = @cImport(@cInclude("raylib.h"));
const Game = @import("game/Game.zig");

pub fn main() !void {
    const screenWidth = 800;
    const screenHeight = 450;

    c.InitWindow(screenWidth, screenHeight, "Shako");
    c.SetTargetFPS(60);

    var game = Game{};
    game.init();

    while (!c.WindowShouldClose()) {
        game.simulate();
    }

    c.CloseWindow();
}
