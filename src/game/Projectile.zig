const std = @import("std");

const c = @cImport(@cInclude("raylib.h"));
const Ecs = @import("../ecs/Ecs.zig");
const MovementComponent = @import("../components/MovementComponent.zig");
const TransformComponent = @import("../components/TransformComponent.zig");
const TextureComponent = @import("../components/TextureComponent.zig");
const CollisionComponent = @import("../components/CollisionComponent.zig");

pub fn spawn(ecs: *Ecs, position: c.Vector2, direction: c.Vector2, velocity: c.Vector2, texture: TextureComponent, size: c.Vector2) void {
    const projectileMovementComponent = MovementComponent{ .direction = direction, .velocity = velocity };
    const projectileTransformComponent = TransformComponent{ .position = position, .scale = size };
    const projectile_collision_component = CollisionComponent{
        .ignore = 0,
        .hitbox = c.Rectangle{
            .x = -size.x,
            .y = -size.y,
            .width = size.x * 2,
            .height = size.y * 2,
        },
    };

    _ = ecs.createEntity(.{ projectileMovementComponent, projectileTransformComponent, texture, projectile_collision_component });
}
