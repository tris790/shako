const std = @import("std");
const c = @cImport({
    @cInclude("raylib.h");
});

const Math = @import("Math.zig");
const Entity = @import("Entity.zig");
const TransformComponent = @import("TransformComponent.zig");
const InputManager = @import("InputManager.zig");

positions: [1]TransformComponent = undefined,
player: Entity = undefined,

pub fn init(self: *@This()) void {
    self.positions[0] = TransformComponent.new(c.Vector2{ .x = 100, .y = 100 }, c.Vector2{ .x = 50, .y = 50 });
}

pub fn simulate(self: *@This()) void {
    // self.positions[0].position.x += 1;
    const movement_direction = InputManager.Movement();
    const movement = Math.Vector2Multiply(movement_direction, c.Vector2{ .x = 10, .y = 10 });
    self.positions[0].position = Math.Vector2Add(self.positions[0].position, movement);
    if (InputManager.Jumping()) {
        self.positions[0].scale = c.Vector2{ .x = 100, .y = 100 };
    } else {
        self.positions[0].scale = c.Vector2{ .x = 50, .y = 50 };
    }
}

pub fn render(self: *@This()) void {
    c.BeginDrawing();
    {
        c.ClearBackground(c.RAYWHITE);
        c.DrawCircleV(self.positions[0].position, self.positions[0].scale.x, c.MAROON);
    }
    c.EndDrawing();
}
