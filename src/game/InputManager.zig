const c = @cImport(@cInclude("raylib.h"));

pub fn Jumping() bool {
    return c.IsKeyDown(c.KEY_SPACE);
}

pub fn Movement() c.Vector2 {
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
