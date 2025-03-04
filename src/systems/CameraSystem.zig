const std = @import("std");
const c = @import("../c.zig");

const Ecs = @import("../ecs/Ecs.zig");

pub fn run(ecs: *Ecs, camera: *c.Camera3D, target: *c.Vector3) void {
    camera.position.x = target.x;
    camera.position.y = target.y + ecs.camera_zoom;
    camera.position.z = target.z + ecs.camera_zoom;
    camera.target = target.*;

    // c.UpdateCamera(camera, c.CAMERA_FREE);
}
