const std = @import("std");
const c = @import("../c.zig");

const Ecs = @import("../ecs/Ecs.zig");

const CAMERA_OFFSET = 500;

pub fn run(ecs: *Ecs, camera: *c.Camera3D, target: *c.Vector3) void {
    _ = ecs;
    camera.position.x = target.x;
    camera.position.y = target.y + CAMERA_OFFSET;
    camera.position.z = target.z + CAMERA_OFFSET;
    camera.target = target.*;

    // c.UpdateCamera(camera, c.CAMERA_FREE);
}
