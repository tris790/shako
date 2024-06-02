const c = @import("c.zig");

pub extern fn Vector2Add(v1: c.Vector2, v2: c.Vector2) c.Vector2;
pub extern fn Vector2AddValue(v: c.Vector2, add: f32) c.Vector2;
pub extern fn Vector2Subtract(v1: c.Vector2, v2: c.Vector2) c.Vector2;
pub extern fn Vector2SubtractValue(v: c.Vector2, sub: f32) c.Vector2;
pub extern fn Vector2Length(v: c.Vector2) f32;
pub extern fn Vector2LengthSqr(v: c.Vector2) f32;
pub extern fn Vector2DotProduct(v1: c.Vector2, v2: c.Vector2) f32;
pub extern fn Vector2Distance(v1: c.Vector2, v2: c.Vector2) f32;
pub extern fn Vector2DistanceSqr(v1: c.Vector2, v2: c.Vector2) f32;
pub extern fn Vector2Angle(v1: c.Vector2, v2: c.Vector2) f32;
pub extern fn Vector2Scale(v: c.Vector2, scale: f32) c.Vector2;
pub extern fn Vector2Multiply(v1: c.Vector2, v2: c.Vector2) c.Vector2;
