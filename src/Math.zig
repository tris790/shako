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

pub extern fn Vector3Add(v1: c.Vector3, v2: c.Vector3) c.Vector3;
pub extern fn Vector3AddValue(v: c.Vector3, add: f32) c.Vector3;
pub extern fn Vector3Subtract(v1: c.Vector3, v2: c.Vector3) c.Vector3;
pub extern fn Vector3SubtractValue(v: c.Vector3, sub: f32) c.Vector3;
pub extern fn Vector3Length(v: c.Vector3) f32;
pub extern fn Vector3LengthSqr(v: c.Vector3) f32;
pub extern fn Vector3DotProduct(v1: c.Vector3, v2: c.Vector3) f32;
pub extern fn Vector3Distance(v1: c.Vector3, v2: c.Vector3) f32;
pub extern fn Vector3DistanceSqr(v1: c.Vector3, v2: c.Vector3) f32;
pub extern fn Vector3Angle(v1: c.Vector3, v2: c.Vector3) f32;
pub extern fn Vector3Scale(v: c.Vector3, scale: f32) c.Vector3;
pub extern fn Vector3Multiply(v1: c.Vector3, v2: c.Vector3) c.Vector3;
