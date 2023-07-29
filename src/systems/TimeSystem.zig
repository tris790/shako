const c = @cImport(@cInclude("raylib.h"));
const Ecs = @import("../ecs/Ecs.zig");
const TimeComponent = @import("../components/TimeComponent.zig");

pub fn run(ecs: *Ecs, times: []TimeComponent, shader: *c.Shader, deltaTime: f32) void {
    _ = ecs;

    c.SetShaderValue(shader.*, c.GetShaderLocation(shader.*, "deltaTime"), @ptrCast(?*const anyopaque, &deltaTime), c.SHADER_UNIFORM_FLOAT);

    for (times) |*time| {
        if (time.remaining > 0) {
            time.remaining -= 1;
        }
    }
}
