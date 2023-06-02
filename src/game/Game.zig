const std = @import("std");
const c = @cImport({
    @cInclude("raylib.h");
});

const Math = @import("../Math.zig");
const Ecs = @import("../ecs/Ecs.zig");
const TransformComponent = @import("../components/TransformComponent.zig");
const MovementComponent = @import("../components/MovementComponent.zig");

ecs: Ecs = Ecs{},

pub fn init(self: *@This()) void {
    var player_transform_component = self.ecs.getComponent(TransformComponent, 0);
    player_transform_component.* = TransformComponent.new(c.Vector2{ .x = 100, .y = 100 }, c.Vector2{ .x = 50, .y = 50 });
    var player_movement_component = self.ecs.getComponent(MovementComponent, 0);
    player_movement_component.* = MovementComponent.new(c.Vector2{ .x = 10, .y = 10 });
}

pub fn simulate(self: *@This()) void {
    self.ecs.runSystems();
}
