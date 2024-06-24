const std = @import("std");
const c = @import("../c.zig");

const Ecs = @import("../ecs/Ecs.zig");

pub fn run(ecs: *Ecs, camera: *c.Camera2D, target: *c.Vector2) void {
    _ = ecs;
    const camera_position_x: f32 = @as(f32, @floatFromInt(c.GetScreenWidth())) / 2.0;
    const camera_position_y: f32 = @as(f32, @floatFromInt(c.GetScreenHeight())) / 2.0;
    camera.target = target.*;
    camera.offset = c.Vector2{
        .x = camera_position_x,
        .y = camera_position_y,
    };
    // camera.rotation = 0.0;
    // camera.zoom = 1.0f;
}
