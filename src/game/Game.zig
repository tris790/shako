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
    var player_transform_component = self.ecs.getComponent(TransformComponent, 0);
    player_transform_component.* = TransformComponent.new(c.Vector2{ .x = 50, .y = 50 }, c.Vector2{ .x = 25, .y = 25 });
    var player_movement_component = self.ecs.getComponent(MovementComponent, 0);
    player_movement_component.* = MovementComponent.new(c.Vector2{ .x = 10, .y = 10 });
    var monster_player_component = self.ecs.getComponent(TextureComponent, 0);
    monster_player_component.* = TextureComponent{ .color = c.BLUE };

    var monster_transform_component = self.ecs.getComponent(TransformComponent, 1);
    monster_transform_component.* = TransformComponent.new(c.Vector2{ .x = 200, .y = 200 }, c.Vector2{ .x = 75, .y = 75 });
    var monster_texture_component = self.ecs.getComponent(TextureComponent, 1);
    monster_texture_component.* = TextureComponent{ .color = c.MAROON };
}

pub fn simulate(self: *@This()) void {
    self.ecs.runSystems();
}
