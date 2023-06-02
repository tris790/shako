const c = @cImport(@cInclude("raylib.h"));

direction: c.Vector2 = c.Vector2{ .x = 0, .y = 0 },
velocity: c.Vector2 = c.Vector2{ .x = 10, .y = 10 },

pub fn new(velocity: c.Vector2) @This() {
    return .{ .velocity = velocity };
}
