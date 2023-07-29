const std = @import("std");
const c = @cImport(@cInclude("raylib.h"));

const Ecs = @import("../ecs/Ecs.zig");
const Shape = @import("../game/Shapes.zig").Shape;

const TextureComponent = @import("../components/TextureComponent.zig");
const TransformComponent = @import("../components/TransformComponent.zig");
const CollisionComponent = @import("../components/CollisionComponent.zig");
const HealthComponent = @import("../components/HealthComponent.zig");

const HP_COLORS = [_]c.Color{ c.RED, c.GREEN };
const HOTBAR_COLORS = [_]c.Color{ c.RED, c.BLUE };

pub fn run(
    ecs: *Ecs,
    transforms: []TransformComponent,
    textures: []TextureComponent,
    collisions: []CollisionComponent,
    healths: []HealthComponent,
    camera: *c.Camera2D,
    fragmentShader: *c.Shader,
) void {
    c.BeginDrawing();
    {
        c.ClearBackground(c.RAYWHITE);

        c.BeginShaderMode(fragmentShader.*);
        c.DrawRectangle(0.0, 0.0, c.GetScreenWidth(), c.GetScreenHeight(), c.WHITE);

        c.BeginMode2D(camera.*);

        renderComponents(ecs, transforms, textures, collisions, healths, camera, fragmentShader);

        c.EndMode2D();
        c.EndShaderMode();

        renderUI(ecs, transforms);
    }
    c.EndDrawing();
}

fn renderComponents(
    ecs: *Ecs,
    transforms: []TransformComponent,
    textures: []TextureComponent,
    collisions: []CollisionComponent,
    healths: []HealthComponent,
    camera: *c.Camera2D,
    fragmentShader: *c.Shader,
) void {
    _ = fragmentShader;
    _ = camera;
    for (transforms, textures, collisions, healths) |transform, texture, *collision, health| {
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

            if (health.health > 0) {
                const health_ratio_left = @intToFloat(f32, health.health) / @intToFloat(f32, health.totalHealth);
                c.DrawRectangleV(transform.position, c.Vector2{ .x = health_ratio_left * 100, .y = 10 }, HP_COLORS[@boolToInt(health_ratio_left > 0.3)]);
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
    const hotbar_element_y_offset = @intToFloat(f32, window_height) - hotbar_element_size.y - hotbar_element_padding;

    const padding = 10;

    var hotbar_index: u8 = 0;
    while (hotbar_index < ecs.hud.hotbarItems.len) {
        const hotbar_element_x_offset = @intToFloat(f32, hotbar_index) * (hotbar_element_size.x + hotbar_element_padding);
        c.DrawRectangleV(
            c.Vector2{ .x = hotbar_element_x_offset, .y = hotbar_element_y_offset },
            hotbar_element_size,
            HOTBAR_COLORS[@boolToInt(hotbar_index == ecs.hud.selectedHotbarIndex)],
        );

        hotbar_index += 1;
    }

    const fps = c.GetFPS();
    var framerate_string: [100]u8 = std.mem.zeroes([100]u8);
    const framerate_string_slice = std.fmt.bufPrint(&framerate_string, "FrameTime {}", .{fps}) catch unreachable;
    c.DrawText(framerate_string_slice.ptr, padding, padding, 30, c.BLACK);
}
