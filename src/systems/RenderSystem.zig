const c = @cImport(@cInclude("raylib.h"));
const Ecs = @import("../ecs/Ecs.zig");
const TransformComponent = @import("../components/TransformComponent.zig");

pub fn run(ecs: *Ecs, transforms: []TransformComponent) void {
    _ = ecs;
    c.BeginDrawing();
    {
        c.ClearBackground(c.RAYWHITE);
        for (transforms) |transform| {
            c.DrawCircleV(transform.position, transform.scale.x, c.MAROON);
        }
    }
    c.EndDrawing();
}
