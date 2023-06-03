const std = @import("std");
const c = @cImport({
    @cInclude("raylib.h");
});

const Math = @import("../Math.zig");
const Ecs = @import("../ecs/Ecs.zig");
const TextureComponent = @import("../components/TextureComponent.zig");
const TransformComponent = @import("../components/TransformComponent.zig");
const MovementComponent = @import("../components/MovementComponent.zig");

ecs: Ecs = Ecs{},

pub fn init(self: *@This()) void {
    const player_transform_component = TransformComponent{ .position = c.Vector2{ .x = 50, .y = 50 }, .scale = c.Vector2{ .x = 25, .y = 25 } };
    const player_movement_component = MovementComponent{ .velocity = c.Vector2{ .x = 10, .y = 10 } };
    const player_texture_component = TextureComponent{ .color = c.BLUE };
    _ = self.ecs.createEntity(.{ player_transform_component, player_movement_component, player_texture_component });

    const monster_transform_component = TransformComponent{ .position = c.Vector2{ .x = 200, .y = 200 }, .scale = c.Vector2{ .x = 75, .y = 75 } };
    const monster_texture_component = TextureComponent{ .color = c.MAROON };
    _ = self.ecs.createEntity(.{ monster_transform_component, monster_texture_component });
}

pub fn simulate(self: *@This()) void {
    self.ecs.runSystems();
}
