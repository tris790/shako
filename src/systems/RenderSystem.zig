const c = @cImport(@cInclude("raylib.h"));
const Ecs = @import("../ecs/Ecs.zig");

const TextureComponent = @import("../components/TextureComponent.zig");
const TransformComponent = @import("../components/TransformComponent.zig");

pub fn run(ecs: *Ecs, transforms: []TransformComponent, textures: []TextureComponent) void {
    _ = ecs;
    c.BeginDrawing();
    {
        c.ClearBackground(c.RAYWHITE);
        for (transforms, textures) |transform, texture| {
            c.DrawCircleV(transform.position, transform.scale.x, texture.color);
        }
    }
    c.EndDrawing();
}
