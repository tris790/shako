const c = @cImport(@cInclude("raylib.h"));

position: c.Vector2,
scale: c.Vector2,

pub fn new(position: c.Vector2, scale: c.Vector2) @This() {
    return @This(){ .position = position, .scale = scale };
}
