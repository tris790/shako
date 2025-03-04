const std = @import("std");
const c = @import("../c.zig");
const Allocator = std.mem.Allocator;

const Ecs = @import("../ecs/Ecs.zig");
const Math = @import("../Math.zig");

const TransformComponent = @import("../components/TransformComponent.zig");
const CollisionComponent = @import("../components/CollisionComponent.zig");

pub fn calculateCollision(collisionTest: CollisionComponent, targetTransform: TransformComponent, targetCollision: CollisionComponent) bool {
    // If either collision is set to be ignored, no collision occurs
    if (collisionTest.ignore != 0 or targetCollision.ignore != 0) {
        return false;
    }

    // Get positions of the first hitbox
    const pos1 = targetTransform.position;
    const size1 = collisionTest.hitbox;

    // Calculate min and max for the first box
    const box1_min = pos1;
    const box1_max = c.Vector3{
        .x = pos1.x + size1.x,
        .y = pos1.y + size1.y,
        .z = pos1.z + size1.z,
    };

    // Get positions of the second hitbox
    const pos2 = targetTransform.position;
    const size2 = targetCollision.hitbox;

    // Calculate min and max for the second box
    const box2_min = pos2;
    const box2_max = c.Vector3{
        .x = pos2.x + size2.x,
        .y = pos2.y + size2.y,
        .z = pos2.z + size2.z,
    };

    // Check for overlap in all three dimensions
    // AABB collision algorithm (axis-aligned bounding box)
    return (box1_min.x <= box2_max.x and box1_max.x >= box2_min.x) and
        (box1_min.y <= box2_max.y and box1_max.y >= box2_min.y) and
        (box1_min.z <= box2_max.z and box1_max.z >= box2_min.z);
}
