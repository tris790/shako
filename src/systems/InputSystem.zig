const std = @import("std");

const c = @import("../c.zig");
const Ecs = @import("../ecs/Ecs.zig");

const TransformComponent = @import("../components/TransformComponent.zig");
const ShapeComponent = @import("../components/ShapeComponent.zig");
const MovementComponent = @import("../components/MovementComponent.zig");
const Projectile = @import("../game/Projectile.zig");
const AbilityKind = @import("../game/Ability.zig").AbilityKind;
const Math = @import("../Math.zig");

pub fn isShooting() bool {
    return c.IsKeyDown(c.KEY_SPACE);
}

pub fn hasToggledDebug() bool {
    return c.IsKeyPressed(c.KEY_H);
}

pub fn hasPressedSpecialAbility() bool {
    return c.IsKeyPressed(c.KEY_V);
}

pub fn isOpeningInventory() bool {
    return c.IsKeyPressed(c.KEY_I);
}

pub fn getZoom() f32 {
    return c.GetMouseWheelMove();
}

pub fn movementDirection() c.Vector3 {
    const right: i32 = @intFromBool(c.IsKeyDown(c.KEY_D));
    const left: i32 = @intFromBool(c.IsKeyDown(c.KEY_A));
    const up: i32 = @intFromBool(c.IsKeyDown(c.KEY_W));
    const down: i32 = @intFromBool(c.IsKeyDown(c.KEY_S));
    const x: i32 = right - left;
    const y: i32 = down - up;

    return c.Vector3{
        .x = @floatFromInt(x),
        .y = 0,
        .z = @floatFromInt(y),
    };
}

pub fn nextHotbarSelection() bool {
    return c.IsKeyPressed(c.KEY_RIGHT);
}

pub fn previousHotbarSelection() bool {
    return c.IsKeyPressed(c.KEY_LEFT);
}

pub fn run(ecs: *Ecs) void {
    var transform_component: *TransformComponent = ecs.getComponent(TransformComponent, 0);
    var movement_component: *MovementComponent = ecs.getComponent(MovementComponent, 0);
    movement_component.direction = movementDirection();

    if (movement_component.direction.x != 0 or movement_component.direction.z != 0) {
        movement_component.last_direction = movement_component.direction;
    }

    if (isShooting()) {
        const texture = ShapeComponent{ .color = c.BLACK };
        Projectile.spawn(
            ecs,
            transform_component.position,
            movement_component.last_direction,
            c.Vector3{ .x = 1000, .z = 1000 },
            texture,
            c.Vector3{ .x = 10, .z = 10 },
        );
    }

    if (hasToggledDebug()) {
        ecs.debug.render_hitboxes = !ecs.debug.render_hitboxes;
    }

    if (hasPressedSpecialAbility()) {
        const selected_ability = ecs.hud.hotbarItems[ecs.hud.selectedHotbarIndex];
        switch (selected_ability) {
            .ScatterShot => {
                const colors = [_]c.Color{ c.PINK, c.GREEN };
                const full_circle_rad = 2 * std.math.pi;
                var remaining_projectiles: u32 = 10;
                const angle_step = full_circle_rad / @as(f32, @floatFromInt(remaining_projectiles));

                while (remaining_projectiles > 0) {
                    const angle = angle_step * @as(f32, @floatFromInt(remaining_projectiles));
                    const opposite = std.math.sin(angle);
                    const adjacent = std.math.cos(angle);
                    const direction = c.Vector3{
                        .x = adjacent,
                        .z = opposite,
                    };

                    const color_index = remaining_projectiles % colors.len;
                    const texture = ShapeComponent{ .color = colors[color_index] };
                    Projectile.spawn(
                        ecs,
                        transform_component.position,
                        direction,
                        c.Vector3{ .x = 1000, .z = 1000 },
                        texture,
                        c.Vector3{ .x = 10, .z = 10 },
                    );

                    remaining_projectiles -= 1;
                }
            },
            .MassiveShot => {
                const texture = ShapeComponent{ .color = c.BLACK };
                Projectile.spawn(
                    ecs,
                    transform_component.position,
                    movement_component.last_direction,
                    c.Vector3{ .x = 100, .z = 100 },
                    texture,
                    c.Vector3{ .x = 10, .z = 10 },
                );
            },
            .Dash => {
                const displacement = Math.Vector3Scale(movement_component.last_direction, 150);
                transform_component.position = Math.Vector3Add(transform_component.position, displacement);
            },
        }
    }

    if (previousHotbarSelection()) {
        if (ecs.hud.selectedHotbarIndex == 0) {
            ecs.hud.selectedHotbarIndex = ecs.hud.hotbarItems.len - 1;
        } else {
            ecs.hud.selectedHotbarIndex -= 1;
        }
    }

    if (nextHotbarSelection()) {
        if (ecs.hud.selectedHotbarIndex == ecs.hud.hotbarItems.len - 1) {
            ecs.hud.selectedHotbarIndex = 0;
        } else {
            ecs.hud.selectedHotbarIndex += 1;
        }
    }

    if (isOpeningInventory()) {
        ecs.inventory.opened = !ecs.inventory.opened;
    }

    const zoom = getZoom();
    if (zoom != 0) {
        ecs.camera_zoom += zoom * -25;
    }
}
