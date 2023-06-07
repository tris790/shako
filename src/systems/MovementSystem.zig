const std = @import("std");
const c = @cImport(@cInclude("raylib.h"));
const Math = @import("../Math.zig");
const Ecs = @import("../ecs/Ecs.zig");
const Collision = @import("../game/Collision.zig");

const TransformComponent = @import("../components/TransformComponent.zig");
const MovementComponent = @import("../components/MovementComponent.zig");
const CollisionComponent = @import("../components/CollisionComponent.zig");
const HealthComponent = @import("../components/HealthComponent.zig");

pub fn run(ecs: *Ecs, transforms: []TransformComponent, movements: []MovementComponent, collisions: []CollisionComponent) void {
    for (transforms, movements, collisions) |*transform, *movement, *collision| {
        const displacement = Math.Vector2Scale(Math.Vector2Multiply(movement.direction, movement.velocity), c.GetFrameTime());

        if (displacement.x != 0 or displacement.y != 0) {
            const newPosition = Math.Vector2Add(transform.position, displacement);

            var gen_allocator = std.heap.GeneralPurposeAllocator(.{}){};
            defer std.debug.assert(gen_allocator.deinit() == .ok);

            var collided_with = std.ArrayList(u32).init(gen_allocator.allocator());
            defer collided_with.deinit();
            const other_transforms = ecs.getAllComponents(TransformComponent);
            const other_collisions = ecs.getAllComponents(CollisionComponent);

            const hitbox_position = collision.addPositionToHitbox(newPosition);
            const test_collision = CollisionComponent{
                .ignore = collision.ignore,
                .is_solid = collision.is_solid,
                .hitbox = c.Rectangle{
                    .x = hitbox_position.x,
                    .y = hitbox_position.y,
                    .width = collision.hitbox.width,
                    .height = collision.hitbox.height,
                },
            };

            var entityId: u32 = 0;
            for (other_transforms, other_collisions) |other_transform, other_collision| {
                entityId += 1;
                const should_ignore = collision.ignore == other_collision.ignore;
                if (should_ignore) {
                    continue;
                }

                const hasCollided = Collision.calculateCollision(test_collision, other_transform, other_collision);
                if (hasCollided and (!collision.is_solid or !other_collision.is_solid)) {
                    std.log.info("Collision between non solid objects", .{});
                } else if (hasCollided) {
                    collided_with.append(entityId) catch {
                        std.log.err("Couldn't append collision {}", .{collision});
                    };

                    movement.direction = c.Vector2{ .x = 0, .y = 0 };
                }
            }

            if (collided_with.items.len == 0) {
                transform.position = newPosition;
            } else {
                std.log.info("Colliding with {} entities", .{collided_with.items.len});
                for (collided_with.items) |id| {
                    var health = ecs.getComponent(HealthComponent, id - 1);
                    health.damageToTake += 10;
                }
            }
        }
    }
}
