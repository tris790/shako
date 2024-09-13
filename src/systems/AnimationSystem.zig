const std = @import("std");
const AnimationComponent = @import("../components/AnimationComponent.zig");
const Ecs = @import("../ecs/Ecs.zig");

const c = @import("../c.zig");

pub fn run(ecs: *Ecs, animations: []AnimationComponent) void {
    for (animations) |*animation| {
        if (animation.current_index >= @as(f32, @floatFromInt(animation.frame_count))) animation.current_index = 0;

        if (animation.animation_asset_id > 0 or animation.model_asset_id > 0) {
            const model_asset = ecs.assets.items[animation.model_asset_id].data.model;
            const animation_asset = ecs.assets.items[animation.animation_asset_id].data.animation.data.*;
            c.UpdateModelAnimation(model_asset, animation_asset, @intFromFloat(animation.current_index));
            animation.current_index += animation.animation_speed * c.GetFrameTime();
        }
    }
}
