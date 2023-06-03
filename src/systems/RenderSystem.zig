const c = @cImport(@cInclude("raylib.h"));
const Ecs = @import("../ecs/Ecs.zig");
const Shape = @import("../game/Shapes.zig").Shape;

const TextureComponent = @import("../components/TextureComponent.zig");
const TransformComponent = @import("../components/TransformComponent.zig");
const CollisionComponent = @import("../components/CollisionComponent.zig");

pub fn run(ecs: *Ecs, transforms: []TransformComponent, textures: []TextureComponent, collisions: []CollisionComponent) void {
    c.BeginDrawing();
    {
        c.ClearBackground(c.RAYWHITE);
        for (transforms, textures, collisions) |transform, texture, *collision| {
            if (transform.world_id >= 0) {
                if (ecs.debug.render_hitboxes) {
                    const hitbox_position = collision.addPositionToHitbox(transform.position);
                    const hitbox = c.Rectangle{ .x = hitbox_position.x, .y = hitbox_position.y, .width = collision.hitbox.width, .height = collision.hitbox.height };
                    c.DrawRectangleRec(hitbox, c.YELLOW);
                }

                switch (texture.shape) {
                    .Circle => c.DrawCircleV(transform.position, transform.scale.x, texture.color),
                    .Rectangle => c.DrawRectangleV(transform.position, transform.scale, texture.color),
                }
            }
        }
    }
    c.EndDrawing();
}
