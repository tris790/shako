const c = @cImport(@cInclude("raylib.h"));
const Ecs = @import("../ecs/Ecs.zig");

const MovementComponent = @import("../components/MovementComponent.zig");

pub fn jumping() bool {
    return c.IsKeyDown(c.KEY_SPACE);
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
    var movement_component: *MovementComponent = ecs.getComponent(MovementComponent, 0);
    movement_component.direction = movement();
}
