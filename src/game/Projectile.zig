const std = @import("std");

const c = @import("../c.zig");
const Ecs = @import("../ecs/Ecs.zig");
const MovementComponent = @import("../components/MovementComponent.zig");
const TransformComponent = @import("../components/TransformComponent.zig");
const ShapeComponent = @import("../components/ShapeComponent.zig");
const CollisionComponent = @import("../components/CollisionComponent.zig");

pub fn spawn(ecs: *Ecs, position: c.Vector3, direction: c.Vector3, velocity: c.Vector3, texture: ShapeComponent, size: c.Vector3) void {
    const projectileMovementComponent = MovementComponent{ .direction = direction, .velocity = velocity };
    const projectileTransformComponent = TransformComponent{ .position = position, .scale = size };
    const projectile_collision_component = CollisionComponent{
        .ignore = 0,
        .hitbox = size,
    };

    _ = ecs.createEntity(.{ projectileMovementComponent, projectileTransformComponent, texture, projectile_collision_component });
}
