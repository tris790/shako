const std = @import("std");
const c = @cImport(@cInclude("raylib.h"));
const Shape = @import("../game/Shapes.zig").Shape;

const Math = @import("../Math.zig");
const Ecs = @import("../ecs/Ecs.zig");

const TextureComponent = @import("../components/TextureComponent.zig");
const CollisionComponent = @import("../components/CollisionComponent.zig");
const TransformComponent = @import("../components/TransformComponent.zig");
const MovementComponent = @import("../components/MovementComponent.zig");
const HealthComponent = @import("../components/HealthComponent.zig");

ecs: Ecs = Ecs{},

pub fn init(self: *@This()) void {
    createPlayer(&self.ecs);
    createMonster(&self.ecs);
    createWall(&self.ecs);
}

pub fn simulate(self: *@This()) void {
    self.ecs.runSystems();
}

fn createPlayer(ecs: *Ecs) void {
    const width = 50;
    const height = 50;
    const player_transform_component = TransformComponent{ .position = c.Vector2{ .x = 50, .y = 50 }, .scale = c.Vector2{ .x = width / 2, .y = height / 2 } };
    const player_movement_component = MovementComponent{ .velocity = c.Vector2{ .x = 1000, .y = 1000 } };
    const player_texture_component = TextureComponent{ .color = c.BLUE };
    const player_health_component = HealthComponent{ .health = 100 };

    const player_collision_component = CollisionComponent{
        .ignore = 0,
        .hitbox = c.Rectangle{
            .x = -(width / 2),
            .y = -(height / 2),
            .width = width,
            .height = height,
        },
    };
    _ = ecs.createEntity(.{ player_transform_component, player_movement_component, player_texture_component, player_collision_component, player_health_component });
}

fn createMonster(ecs: *Ecs) void {
    const width = 50;
    const height = 50;
    const monster_transform_component = TransformComponent{ .position = c.Vector2{ .x = 200, .y = 200 }, .scale = c.Vector2{ .x = width / 2, .y = height / 2 } };
    const monster_collision_component = CollisionComponent{
        .ignore = 1,
        .hitbox = c.Rectangle{
            .x = -(width / 2),
            .y = -(height / 2),
            .width = width,
            .height = height,
        },
    };
    const monster_texture_component = TextureComponent{ .color = c.MAROON };
    const monster_health_component = HealthComponent{ .health = 100 };
    _ = ecs.createEntity(.{ monster_transform_component, monster_texture_component, monster_collision_component, monster_health_component });
}

fn createWall(ecs: *Ecs) void {
    const width = 100;
    const height = 50;
    const wall_transform_component = TransformComponent{ .position = c.Vector2{ .x = 300, .y = 300 }, .scale = c.Vector2{ .x = width, .y = height } };
    const wall_collision_component = CollisionComponent{
        .ignore = 2,
        .hitbox = c.Rectangle{
            .x = 0,
            .y = 0,
            .width = width,
            .height = height,
        },
    };
    const wall_texture_component = TextureComponent{ .color = c.BLACK, .shape = Shape.Rectangle };
    _ = ecs.createEntity(.{ wall_transform_component, wall_texture_component, wall_collision_component });
}
