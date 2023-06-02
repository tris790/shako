const std = @import("std");
const t = @import("type");

const Entity = @import("Entity.zig");
const MovementComponent = @import("../components/MovementComponent.zig");
const TextureComponent = @import("../components/TextureComponent.zig");
const TransformComponent = @import("../components/TransformComponent.zig");

const InputSystem = @import("../systems/InputSystem.zig");
const MovementSystem = @import("../systems/MovementSystem.zig");
const RenderSystem = @import("../systems/RenderSystem.zig");

transforms: [2]TransformComponent = undefined,
movements: [2]MovementComponent = undefined,
textures: [2]TextureComponent = undefined,
player: Entity = undefined,

pub fn getComponent(self: *@This(), comptime T: type, entity_id: u64) *T {
    const selfFields = @typeInfo(@This()).Struct.fields;

    inline for (selfFields) |f| {
        const fieldTypeInfo = @typeInfo(f.type);
        if (fieldTypeInfo == .Array) {
            if (fieldTypeInfo.Array.child == T) {
                return &@field(self, f.name)[entity_id];
            }
        }
    }
}

pub fn runSystems(self: *@This()) void {
    InputSystem.run(self);
    MovementSystem.run(self, &self.transforms, &self.movements);
    RenderSystem.run(self, &self.transforms, &self.textures);
}
