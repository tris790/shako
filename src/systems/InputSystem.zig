const std = @import("std");

const c = @cImport(@cInclude("raylib.h"));
const Ecs = @import("../ecs/Ecs.zig");

const TransformComponent = @import("../components/TransformComponent.zig");
const MovementComponent = @import("../components/MovementComponent.zig");
const Projectile = @import("../game/Projectile.zig");

pub fn isShooting() bool {
    return c.IsKeyDown(c.KEY_SPACE);
}

pub fn hasToggledDebug() bool {
    return c.IsKeyPressed(c.KEY_H);
}

pub fn movement() c.Vector2 {
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
    movement_component.direction = movement();

    if (movement_component.direction.x != 0 or movement_component.direction.y != 0) {
        movement_component.last_direction = movement_component.direction;
    }

    if (isShooting()) {
        Projectile.spawn(ecs, transform_component.position, movement_component.last_direction, c.Vector2{ .x = 5, .y = 5 });
    }

    if (hasToggledDebug()) {
        ecs.debug.render_hitboxes = !ecs.debug.render_hitboxes;
    }
}
