const std = @import("std");
const c = @cImport(@cInclude("raylib.h"));
const Math = @import("../Math.zig");
const Ecs = @import("../ecs/Ecs.zig");
const Collision = @import("../game/Collision.zig");

const TransformComponent = @import("../components/TransformComponent.zig");
const MovementComponent = @import("../components/MovementComponent.zig");
const CollisionComponent = @import("../components/CollisionComponent.zig");

pub fn run(ecs: *Ecs, transforms: []TransformComponent, movements: []MovementComponent, collisions: []CollisionComponent) void {
    for (transforms, movements, collisions) |*transform, *movement, *collision| {
        const displacement = Math.Vector2Multiply(movement.direction, movement.velocity);

        if (displacement.x != 0 or displacement.y != 0) {
            const newPosition = Math.Vector2Add(transform.position, displacement);

            var gen_allocator = std.heap.GeneralPurposeAllocator(.{}){};
            defer std.debug.assert(gen_allocator.deinit() == .ok);

            var collided_with = std.ArrayList(CollisionComponent).init(gen_allocator.allocator());
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

            for (other_transforms, other_collisions) |other_transform, other_collision| {
                const should_ignore = collision.ignore == other_collision.ignore;
                if (should_ignore) {
                    continue;
                }

                const hasCollided = Collision.calculateCollision(test_collision, other_transform, other_collision);
                if (hasCollided and (!collision.is_solid or !other_collision.is_solid)) {
                    std.log.info("Collision between non solid objects", .{});
                } else if (hasCollided) {
                    collided_with.append(other_collision) catch {
                        std.log.err("Couldn't append collision {}", .{collision});
                    };

                    movement.direction = c.Vector2{ .x = 0, .y = 0 };
                }
            }

            if (collided_with.items.len <= 1) {
                transform.position = newPosition;
            } else {
                std.log.info("Colliding with {} entities", .{collided_with.items.len});
            }
        }
    }
}
