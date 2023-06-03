const std = @import("std");
const t = @import("type");

const Entity = @import("Entity.zig");
const MovementComponent = @import("../components/MovementComponent.zig");
const TextureComponent = @import("../components/TextureComponent.zig");
const TransformComponent = @import("../components/TransformComponent.zig");
const TimeComponent = @import("../components/TimeComponent.zig");

const InputSystem = @import("../systems/InputSystem.zig");
const MovementSystem = @import("../systems/MovementSystem.zig");
const RenderSystem = @import("../systems/RenderSystem.zig");
const TimeSystem = @import("../systems/TimeSystem.zig");

entityCount: u32 = 0,
transforms: [1000]TransformComponent = undefined,
movements: [1000]MovementComponent = undefined,
textures: [1000]TextureComponent = undefined,
times: [1000]TimeComponent = undefined,
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

pub fn createEntity(self: *@This(), components: anytype) u32 {
    const newEntityId = self.entityCount;
    self.entityCount = newEntityId + 1;
    const componentsTypes = @typeInfo(@TypeOf(components)).Struct.fields;

    inline for (componentsTypes) |component| {
        const ecsFields = @typeInfo(@This()).Struct.fields;

        inline for (ecsFields) |f| {
            const ecsField = @typeInfo(f.type);
            if (ecsField == .Array) {
                if (ecsField.Array.child == component.type) {
                    @field(self, f.name)[newEntityId] = @field(components, component.name);
                }
            }
        }
    }

    return newEntityId;
}

pub fn runSystems(self: *@This()) void {
    InputSystem.run(self);
    TimeSystem.run(self, &self.times);
    MovementSystem.run(self, &self.transforms, &self.movements);
    RenderSystem.run(self, &self.transforms, &self.textures);
}
