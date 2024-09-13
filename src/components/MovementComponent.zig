const c = @import("../c.zig");

direction: c.Vector3 = c.Vector3{ .x = 0, .y = 0, .z = 0 },
last_direction: c.Vector3 = c.Vector3{ .x = 1, .y = 0, .z = 0 },
velocity: c.Vector3 = c.Vector3{ .x = 10, .y = 10, .z = 0 },
