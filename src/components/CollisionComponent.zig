const c = @cImport(@cInclude("raylib.h"));

ignore: u8,
is_solid: bool = true,
hitbox: c.Rectangle,

pub fn addPositionToHitbox(self: *@This(), position: c.Vector2) c.Vector2 {
    return c.Vector2{
        .x = position.x + self.hitbox.x,
        .y = position.y + self.hitbox.y,
    };
}
