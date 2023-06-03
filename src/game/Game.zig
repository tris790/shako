const std = @import("std");
const c = @cImport(@cInclude("raylib.h"));

const Math = @import("../Math.zig");
const Ecs = @import("../ecs/Ecs.zig");
const TextureComponent = @import("../components/TextureComponent.zig");
const CollisionComponent = @import("../components/CollisionComponent.zig");
const TransformComponent = @import("../components/TransformComponent.zig");
const MovementComponent = @import("../components/MovementComponent.zig");

ecs: Ecs = Ecs{},

pub fn init(self: *@This()) void {
    createPlayer(&self.ecs);
    createMonster(&self.ecs);
}

pub fn simulate(self: *@This()) void {
    self.ecs.runSystems();
}

fn createPlayer(ecs: *Ecs) void {
    const width = 50;
    const height = 50;
    const player_transform_component = TransformComponent{ .position = c.Vector2{ .x = 50, .y = 50 }, .scale = c.Vector2{ .x = width / 2, .y = height / 2 } };
    const player_movement_component = MovementComponent{ .velocity = c.Vector2{ .x = 10, .y = 10 } };
    const player_texture_component = TextureComponent{ .color = c.BLUE };

    const player_collision_component = CollisionComponent{ .hitbox = c.Rectangle{
        .x = -(width / 2),
        .y = -(height / 2),
        .width = width,
        .height = height,
    } };
    _ = ecs.createEntity(.{ player_transform_component, player_movement_component, player_texture_component, player_collision_component });
}

fn createMonster(ecs: *Ecs) void {
    const width = 50;
    const height = 50;
    const monster_transform_component = TransformComponent{ .position = c.Vector2{ .x = 200, .y = 200 }, .scale = c.Vector2{ .x = width / 2, .y = height / 2 } };
    const monster_collision_component = CollisionComponent{ .hitbox = c.Rectangle{
        .x = -(width / 2),
        .y = -(height / 2),
        .width = width,
        .height = height,
    } };
    const monster_texture_component = TextureComponent{ .color = c.MAROON };
    _ = ecs.createEntity(.{ monster_transform_component, monster_texture_component, monster_collision_component });
}
