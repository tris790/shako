const std = @import("std");
const Allocator = std.mem.Allocator;

const Ecs = @import("../ecs/Ecs.zig");
const Math = @import("../Math.zig");

const TransformComponent = @import("../components/TransformComponent.zig");
const CollisionComponent = @import("../components/CollisionComponent.zig");

pub fn calculateCollision(collisionTest: CollisionComponent, targetTransform: TransformComponent, targetCollision: CollisionComponent) bool {
    const a_left = collisionTest.hitbox.x;
    const a_right = collisionTest.hitbox.x + collisionTest.hitbox.width;
    const a_top = collisionTest.hitbox.y;
    const a_bottom = collisionTest.hitbox.y + collisionTest.hitbox.height;

    const b_left = targetTransform.position.x + targetCollision.hitbox.x;
    const b_right = targetTransform.position.x + targetCollision.hitbox.x + targetCollision.hitbox.width;
    const b_top = targetTransform.position.y + targetCollision.hitbox.y;
    const b_bottom = targetTransform.position.y + targetCollision.hitbox.y + targetCollision.hitbox.height;

    return a_left < b_right and a_right > b_left and a_top < b_bottom and a_bottom > b_top;
}
