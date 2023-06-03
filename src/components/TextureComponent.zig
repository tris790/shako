const c = @cImport(@cInclude("raylib.h"));
const Shape = @import("../game/Shapes.zig").Shape;

color: c.Color = c.MAROON,
shape: Shape = .Circle,
