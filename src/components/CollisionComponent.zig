const c = @import("../c.zig");

ignore: u8,
is_solid: bool = true,
hitbox: c.Rectangle,

pub fn addPositionToHitbox(self: *@This(), position: c.Vector3) c.Vector3 {
    return c.Vector3{
        .x = position.x + self.hitbox.x,
        .y = position.y,
        .z = position.z + self.hitbox.y,
    };
}
