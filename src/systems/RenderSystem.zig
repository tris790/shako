const std = @import("std");
const c = @import("../c.zig");

const Ecs = @import("../ecs/Ecs.zig");
const Shape = @import("../game/Shapes.zig").Shape;
const Asset = @import("../game/Asset.zig");
const Ui = @import("../ui/Ui.zig");

const ShapeComponent = @import("../components/ShapeComponent.zig");
const TransformComponent = @import("../components/TransformComponent.zig");
const CollisionComponent = @import("../components/CollisionComponent.zig");
const HealthComponent = @import("../components/HealthComponent.zig");
const InventoryComponent = @import("../components/InventoryComponent.zig");
const RenderComponent = @import("../components/RenderComponent.zig");

const HP_COLORS = [_]c.Color{ c.RED, c.GREEN };
const HOTBAR_COLORS = [_]c.Color{ c.RED, c.BLUE };

pub fn run(
    ecs: *Ecs,
    transforms: []TransformComponent,
    shapes: []ShapeComponent,
    collisions: []CollisionComponent,
    healths: []HealthComponent,
    camera: *c.Camera3D,
    fragmentShader: *c.Shader,
    inventory: *InventoryComponent,
    renders: []RenderComponent,
) void {
    _ = shapes;
    _ = healths;
    c.BeginDrawing();
    {
        c.ClearBackground(c.RAYWHITE);
        // TODO TD: We need a shader for shaped and one for textures I think
        c.BeginShaderMode(fragmentShader.*);
        c.DrawRectangle(0.0, 0.0, c.GetScreenWidth(), c.GetScreenHeight(), c.WHITE);

        c.BeginMode3D(camera.*);

        c.DrawPlane(c.Vector3{ .x = 0, .y = 0, .z = 0 }, c.Vector2{ .x = 1000, .y = 1000 }, c.GRAY);
        renderComponents(ecs, transforms, collisions, renders);
        // renderShapes(ecs, transforms, shapes, collisions, healths);

        c.EndMode3D();
        c.EndShaderMode();

        renderUI(ecs, transforms);
        renderInventory(ecs, inventory);
        // renderUi2();
    }
    c.EndDrawing();
}

fn renderShapes(
    ecs: *Ecs,
    transforms: []TransformComponent,
    shapes: []ShapeComponent,
    collisions: []CollisionComponent,
    healths: []HealthComponent,
) void {
    for (transforms, shapes, collisions, healths) |transform, shape, *collision, health| {
        if (transform.world_id >= 0) {
            if (ecs.debug.render_hitboxes) {
                const hitbox_position = collision.addPositionToHitbox(transform.position);
                c.DrawCube(hitbox_position, collision.hitbox.width, 1, collision.hitbox.height, c.YELLOW);
            }

            switch (shape.shape) {
                .Circle => c.DrawSphere(
                    transform.position,
                    transform.scale.x,
                    shape.color,
                ),
                .Rectangle => c.DrawCubeV(
                    transform.position,
                    transform.scale,
                    shape.color,
                ),
            }

            if (health.health > 0) {
                const health_ratio_left = @as(f32, @floatFromInt(health.health)) / @as(f32, @floatFromInt(health.totalHealth));
                c.DrawRectangleV(
                    c.Vector2{ .x = transform.position.x, .y = transform.position.z },
                    c.Vector2{ .x = health_ratio_left * 100, .y = 10 },
                    HP_COLORS[@intFromBool(health_ratio_left > 0.3)],
                );
            }
        }
    }
}

fn renderComponents(
    ecs: *Ecs,
    transforms: []TransformComponent,
    collisions: []CollisionComponent,
    renders: []RenderComponent,
) void {
    for (transforms, renders, collisions) |transform, render, *collision| {
        if (transform.world_id >= 0) {
            if (ecs.debug.render_hitboxes) {
                const hitbox_position = collision.addPositionToHitbox(transform.position);
                const hitbox = c.Rectangle{ .x = hitbox_position.x, .y = hitbox_position.z, .width = collision.hitbox.width, .height = collision.hitbox.height };
                c.DrawRectangleRec(hitbox, c.YELLOW);
            }

            if (render.asset_id > 0) {
                const asset: Asset = ecs.assets.items[render.asset_id];
                if (asset.data == Asset.AssetType.model) {
                    c.DrawModel(asset.data.model, transform.position, transform.scale.x, c.WHITE);
                }
            }
        }
    }
}

fn renderUI(
    ecs: *Ecs,
    transforms: []TransformComponent,
) void {
    _ = transforms;
    const window_height = c.GetScreenHeight();
    const window_width = c.GetScreenWidth();
    _ = window_width;
    const hotbar_element_padding = 5.0;
    const hotbar_element_size = c.Vector2{ .x = 20, .y = 20 };
    const hotbar_element_y_offset = @as(f32, @floatFromInt(window_height)) - hotbar_element_size.y - hotbar_element_padding;

    const padding = 10;

    var hotbar_index: u8 = 0;
    while (hotbar_index < ecs.hud.hotbarItems.len) {
        const hotbar_element_x_offset = @as(f32, @floatFromInt(hotbar_index)) * (hotbar_element_size.x + hotbar_element_padding);
        c.DrawRectangleV(
            c.Vector2{ .x = hotbar_element_x_offset, .y = hotbar_element_y_offset },
            hotbar_element_size,
            HOTBAR_COLORS[@intFromBool(hotbar_index == ecs.hud.selectedHotbarIndex)],
        );

        hotbar_index += 1;
    }

    const fps = c.GetFPS();
    var framerate_string: [100]u8 = std.mem.zeroes([100]u8);
    const framerate_string_slice = std.fmt.bufPrint(&framerate_string, "FrameTime {}", .{fps}) catch unreachable;
    c.DrawText(framerate_string_slice.ptr, padding, padding, 30, c.BLACK);
}

fn renderInventory(ecs: *Ecs, inventory: *InventoryComponent) void {
    _ = ecs;
    if (!inventory.opened) return;

    const width = 500;
    const height = 300;
    const inventory_slot_width = 50;
    const inventory_slot_height = 50;
    const inventory_slot_spacing = 10;

    const window_width = c.GetScreenWidth();
    const window_height = c.GetScreenHeight();
    const inventory_pos = centerElement(width, height, window_width, window_height);
    c.DrawRectangle(inventory_pos[0], inventory_pos[1], width, height, c.GRAY);

    var index: u8 = 0;
    for (inventory.items) |item| {
        _ = item;
        const item_pos = centerElementRelative(inventory_slot_width, inventory_slot_height, inventory_slot_width, inventory_slot_height, inventory_pos);

        c.DrawRectangle(
            item_pos[0],
            index * (inventory_slot_height + inventory_slot_spacing) + inventory_pos[1],
            inventory_slot_width,
            inventory_slot_height,
            c.RED,
        );
        index += 1;
    }
}

fn renderUi2() void {
    Ui.render();
}

fn centerElement(width: c_int, height: c_int, container_width: c_int, container_height: c_int) [2]c_int {
    const x: f32 = @floatFromInt(container_width - width);
    const y: f32 = @floatFromInt(container_height - height);
    const half_x: c_int = @intFromFloat(x / 2.0);
    const half_y: c_int = @intFromFloat(y / 2.0);
    return .{ half_x, half_y };
}

fn centerElementRelative(width: c_int, height: c_int, container_width: c_int, container_height: c_int, relativeTo: [2]c_int) [2]c_int {
    const pos = centerElement(width, height, container_width, container_height);
    return .{
        (pos[0] + relativeTo[0]),
        (pos[1] + relativeTo[1]),
    };
}
