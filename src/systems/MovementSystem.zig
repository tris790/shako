const std = @import("std");
const c = @cImport(@cInclude("raylib.h"));
const Math = @import("../Math.zig");
const Ecs = @import("../ecs/Ecs.zig");

const TransformComponent = @import("../components/TransformComponent.zig");
const MovementComponent = @import("../components/MovementComponent.zig");

pub fn run(_: *Ecs, transforms: []TransformComponent, movements: []MovementComponent) void {
    for (transforms, movements) |*transform, movement| {
        const displacement = Math.Vector2Multiply(movement.direction, movement.velocity);
        const newPosition = Math.Vector2Add(transform.position, displacement);
        transform.position = newPosition;
    }
}
