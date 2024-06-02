const std = @import("std");
const c = @cImport(@cInclude("raylib.h"));
const Game = @import("game/Game.zig");

// __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia

pub fn main() !void {
    const screenWidth = 800;
    const screenHeight = 450;

    c.InitWindow(screenWidth, screenHeight, "Shako");
    c.SetTargetFPS(60);

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    var game = Game{ .allocator = arena.allocator() };
    game.init();

    while (!c.WindowShouldClose()) {
        game.simulate();
    }

    c.CloseWindow();
}
