const c = @cImport(@cInclude("raylib.h"));

direction: c.Vector2 = c.Vector2{ .x = 0, .y = 0 },
last_direction: c.Vector2 = c.Vector2{ .x = 1, .y = 0 },
velocity: c.Vector2 = c.Vector2{ .x = 10, .y = 10 },
