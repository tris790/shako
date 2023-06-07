const std = @import("std");

const c = @cImport(@cInclude("raylib.h"));
const Ecs = @import("../ecs/Ecs.zig");

const TransformComponent = @import("../components/TransformComponent.zig");
const TextureComponent = @import("../components/TextureComponent.zig");
const MovementComponent = @import("../components/MovementComponent.zig");
const Projectile = @import("../game/Projectile.zig");

pub fn isShooting() bool {
    return c.IsKeyDown(c.KEY_SPACE);
}

pub fn hasToggledDebug() bool {
    return c.IsKeyPressed(c.KEY_H);
}

pub fn hasPressedSpecialAbility() bool {
    return c.IsKeyPressed(c.KEY_V);
}

pub fn movementDirection() c.Vector2 {
    const right = @intCast(i32, @boolToInt(c.IsKeyDown(c.KEY_RIGHT)));
    const left = @intCast(i32, @boolToInt(c.IsKeyDown(c.KEY_LEFT)));
    const up = @intCast(i32, @boolToInt(c.IsKeyDown(c.KEY_UP)));
    const down = @intCast(i32, @boolToInt(c.IsKeyDown(c.KEY_DOWN)));
    const x = right - left;
    const y = down - up;

    return c.Vector2{
        .x = @intToFloat(f32, x),
        .y = @intToFloat(f32, y),
    };
}

pub fn run(ecs: *Ecs) void {
    var transform_component: *TransformComponent = ecs.getComponent(TransformComponent, 0);
    var movement_component: *MovementComponent = ecs.getComponent(MovementComponent, 0);
    movement_component.direction = movementDirection();

    if (movement_component.direction.x != 0 or movement_component.direction.y != 0) {
        movement_component.last_direction = movement_component.direction;
    }

    if (isShooting()) {
        const texture = TextureComponent{ .color = c.BLACK };
        Projectile.spawn(ecs, transform_component.position, movement_component.last_direction, c.Vector2{ .x = 1000, .y = 1000 }, texture);
    }

    if (hasToggledDebug()) {
        ecs.debug.render_hitboxes = !ecs.debug.render_hitboxes;
    }

    if (hasPressedSpecialAbility()) {
        const colors = [_]c.Color{ c.PINK, c.GREEN };
        const full_circle_rad = 2 * std.math.pi;
        var remaining_projectiles: u32 = 10;
        const angle_step = full_circle_rad / @intToFloat(f32, remaining_projectiles);

        while (remaining_projectiles > 0) {
            const angle = angle_step * @intToFloat(f32, remaining_projectiles);
            const opposite = std.math.sin(angle);
            const adjacent = std.math.cos(angle);
            const direction = c.Vector2{
                .x = adjacent,
                .y = opposite,
            };

            const color_index = remaining_projectiles % colors.len;
            const texture = TextureComponent{ .color = colors[color_index] };
            Projectile.spawn(
                ecs,
                transform_component.position,
                direction,
                c.Vector2{ .x = 1000, .y = 1000 },
                texture,
            );

            remaining_projectiles -= 1;
        }
    }
}
