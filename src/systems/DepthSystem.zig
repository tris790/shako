const std = @import("std");
const c = @cImport(@cInclude("raylib.h"));

const Ecs = @import("../ecs/Ecs.zig");

const HealthComponent = @import("../components/HealthComponent.zig");

pub fn run(ecs: *Ecs, shader: *c.Shader, depth: f32) void {
    _ = ecs;
    c.SetShaderValue(shader.*, c.GetShaderLocation(shader.*, "depth"), @ptrCast(?*const anyopaque, &depth), c.SHADER_UNIFORM_FLOAT);
    // std.log.info("Depth: {}", .{@floatToInt(u32, depth)});
}
