const c = @cImport(@cInclude("raylib.h"));

is_solid: bool = true,
colliding: bool = false,
hitbox: c.Rectangle,

pub fn addPositionToHitbox(self: *@This(), position: c.Vector2) c.Vector2 {
    return c.Vector2{
        .x = position.x + self.hitbox.x,
        .y = position.y + self.hitbox.y,
    };
}
