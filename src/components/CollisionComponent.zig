const c = @import("../c.zig");

ignore: u8,
is_solid: bool = true,
hitbox: c.Vector3,

pub fn addPositionToHitbox(self: *@This(), position: c.Vector3) c.Vector3 {
    return c.Vector3{
        .x = position.x + self.hitbox.x,
        .y = position.y + self.hitbox.y,
        .z = position.z + self.hitbox.z,
    };
}
