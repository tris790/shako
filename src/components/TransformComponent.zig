const c = @cImport(@cInclude("raylib.h"));

position: c.Vector2,
scale: c.Vector2,
world_id: u8 = 0,
