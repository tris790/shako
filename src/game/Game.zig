const std = @import("std");
const c = @import("../c.zig");
const Shape = @import("../game/Shapes.zig").Shape;

const Math = @import("../Math.zig");
const Ecs = @import("../ecs/Ecs.zig");
const Asset = @import("./Asset.zig");

const ShapeComponent = @import("../components/ShapeComponent.zig");
const CollisionComponent = @import("../components/CollisionComponent.zig");
const TransformComponent = @import("../components/TransformComponent.zig");
const MovementComponent = @import("../components/MovementComponent.zig");
const HealthComponent = @import("../components/HealthComponent.zig");
const InventoryComponent = @import("../components/InventoryComponent.zig");
const RenderComponent = @import("../components/RenderComponent.zig");
const AnimationComponent = @import("../components/AnimationComponent.zig");

const Allocator = std.mem.Allocator;

allocator: Allocator,

ecs: Ecs = Ecs{},

pub fn init(self: *@This()) void {
    self.ecs.loadAssets(self.allocator);
    self.ecs.loadShaders();
    self.ecs.camera.position = c.Vector3{ .x = 0, .y = 500, .z = 500 };
    self.ecs.camera.target = c.Vector3{ .x = 0, .y = 0, .z = 0 };
    self.ecs.camera.up = c.Vector3{ .x = 0.0, .y = 1.0, .z = 0.0 };
    self.ecs.camera.fovy = 45.0; // Camera field-of-view Y
    self.ecs.camera.projection = c.CAMERA_PERSPECTIVE; // Camera mode type
    createPlayer(&self.ecs);
    createMonster(&self.ecs);
    createWall(&self.ecs);
    createInventory(&self.ecs);
}

pub fn simulate(self: *@This()) void {
    self.ecs.runSystems();
}

fn createPlayer(ecs: *Ecs) void {
    const width = 50;
    const height = 50;
    const player_transform_component = TransformComponent{
        .position = c.Vector3{ .x = 0, .y = 0, .z = 0 },
        .scale = c.Vector3{ .x = 1, .y = 1, .z = 1 },
    };
    const player_movement_component = MovementComponent{ .velocity = c.Vector3{ .x = 1000, .y = 0, .z = 1000 } };
    const player_render_component = RenderComponent{ .asset_id = 1 };
    const player_health_component = HealthComponent{ .health = 100, .totalHealth = 100 };
    const player_animation_component = AnimationComponent{ .model_asset_id = 1, .animation_asset_id = 2, .current_index = 0 };

    const player_collision_component = CollisionComponent{
        .ignore = 0,
        .hitbox = c.Rectangle{
            .x = -(width / 2),
            .y = -(height / 2),
            .width = width,
            .height = height,
        },
    };

    _ = ecs.createEntity(.{
        player_transform_component,
        player_movement_component,
        player_render_component,
        player_collision_component,
        player_health_component,
        player_animation_component,
    });
}

fn createMonster(ecs: *Ecs) void {
    const width = 50;
    const height = 50;
    const monster_transform_component = TransformComponent{
        .position = c.Vector3{ .x = 50, .y = 0, .z = 0 },
        .scale = c.Vector3{ .x = 1, .y = 1, .z = 1 },
    };
    const monster_collision_component = CollisionComponent{
        .ignore = 1,
        .hitbox = c.Rectangle{
            .x = -(width / 2),
            .y = -(height / 2),
            .width = width,
            .height = height,
        },
    };
    const monster_render_component = RenderComponent{ .asset_id = 3 };
    const monster_health_component = HealthComponent{ .health = 100, .totalHealth = 100 };
    _ = ecs.createEntity(.{ monster_transform_component, monster_render_component, monster_collision_component, monster_health_component });
}

fn createWall(ecs: *Ecs) void {
    const width = 100;
    const height = 50;
    const wall_transform_component = TransformComponent{
        .position = c.Vector3{ .x = -300, .y = 0, .z = -300 },
        .scale = c.Vector3{ .x = width, .y = 1, .z = height },
    };
    const wall_collision_component = CollisionComponent{
        .ignore = 2,
        .hitbox = c.Rectangle{
            .x = wall_transform_component.position.x,
            .y = wall_transform_component.position.z,
            .width = width,
            .height = height,
        },
    };
    const wall_texture_component = ShapeComponent{ .color = c.BLACK, .shape = Shape.Rectangle };
    _ = ecs.createEntity(.{ wall_transform_component, wall_texture_component, wall_collision_component });
}

fn createInventory(ecs: *Ecs) void {
    _ = ecs;
}
