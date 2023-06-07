const std = @import("std");
const c = @cImport(@cInclude("raylib.h"));

const Ecs = @import("../ecs/Ecs.zig");

const HealthComponent = @import("../components/HealthComponent.zig");

pub fn run(ecs: *Ecs, healths: []HealthComponent) void {
    _ = ecs;
    var entityId: u32 = 0;
    for (healths) |*health| {
        entityId += 1;
        if (health.dead) {
            return;
        }

        // TODO: we probably need to watchout for overflow and underflow
        health.health -= health.damageToTake;
        health.healing += health.healing;

        health.healing = 0;
        health.damageToTake = 0;

        if (health.health <= 0) {
            health.dead = true;
            std.log.info("[Entity {}] hp reached 0", .{entityId});
        }
    }
}
