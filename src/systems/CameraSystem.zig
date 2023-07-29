const std = @import("std");
const c = @cImport(@cInclude("raylib.h"));

const Ecs = @import("../ecs/Ecs.zig");

pub fn run(ecs: *Ecs, camera: *c.Camera2D, target: *c.Vector2) void {
    _ = ecs;
    camera.target = target.*;
    camera.offset = c.Vector2{
        .x = @intToFloat(f32, c.GetScreenWidth()) / 2,
        .y = @intToFloat(f32, c.GetScreenHeight()) / 2,
    };
    // camera.rotation = 0.0;
    // camera.zoom = 1.0f;
}
