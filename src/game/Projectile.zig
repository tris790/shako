const std = @import("std");

const c = @cImport(@cInclude("raylib.h"));
const Ecs = @import("../ecs/Ecs.zig");
const MovementComponent = @import("../components/MovementComponent.zig");
const TransformComponent = @import("../components/TransformComponent.zig");
const TextureComponent = @import("../components/TextureComponent.zig");
const CollisionComponent = @import("../components/CollisionComponent.zig");

pub fn spawn(ecs: *Ecs, position: c.Vector2, direction: c.Vector2, velocity: c.Vector2) void {
    const width = 20;
    const height = 20;
    const projectileMovementComponent = MovementComponent{ .direction = direction, .velocity = velocity };
    const projectileTransformComponent = TransformComponent{ .position = position, .scale = c.Vector2{ .x = width / 2, .y = height / 2 } };
    const projectile_texture_component = TextureComponent{ .color = c.BLACK };
    const projectile_collision_component = CollisionComponent{
        .ignore = 0,
        .hitbox = c.Rectangle{
            .x = -(width / 2),
            .y = -(height / 2),
            .width = width,
            .height = height,
        },
    };

    _ = ecs.createEntity(.{ projectileMovementComponent, projectileTransformComponent, projectile_texture_component, projectile_collision_component });
}
