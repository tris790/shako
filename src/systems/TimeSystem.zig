const Ecs = @import("../ecs/Ecs.zig");
const TimeComponent = @import("../components/TimeComponent.zig");

pub fn run(ecs: *Ecs, times: []TimeComponent) void {
    _ = ecs;
    for (times) |*time| {
        if (time.remaining > 0) {
            time.remaining -= 1;
        }
    }
}
