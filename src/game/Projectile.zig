const std = @import("std");

const c = @cImport(@cInclude("raylib.h"));
const Ecs = @import("../ecs/Ecs.zig");
const MovementComponent = @import("../components/MovementComponent.zig");
const TransformComponent = @import("../components/TransformComponent.zig");
const TextureComponent = @import("../components/TextureComponent.zig");

pub fn spawn(ecs: *Ecs, position: c.Vector2, direction: c.Vector2, velocity: c.Vector2) void {
    const projectileMovementComponent = MovementComponent{ .direction = direction, .velocity = velocity };
    const projectileTransformComponent = TransformComponent{ .position = position, .scale = c.Vector2{ .x = 10, .y = 10 } };
    const projectile_texture_component = TextureComponent{ .color = c.BLACK };
    _ = ecs.createEntity(.{ projectileMovementComponent, projectileTransformComponent, projectile_texture_component });
}
