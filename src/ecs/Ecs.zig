const std = @import("std");
const Entity = @import("Entity.zig");
const Debug = @import("../game/Debug.zig");

const MovementComponent = @import("../components/MovementComponent.zig");
const TextureComponent = @import("../components/TextureComponent.zig");
const TransformComponent = @import("../components/TransformComponent.zig");
const TimeComponent = @import("../components/TimeComponent.zig");
const CollisionComponent = @import("../components/CollisionComponent.zig");

const InputSystem = @import("../systems/InputSystem.zig");
const MovementSystem = @import("../systems/MovementSystem.zig");
const RenderSystem = @import("../systems/RenderSystem.zig");
const TimeSystem = @import("../systems/TimeSystem.zig");

const MAX_ENTITY = 1000;

entityCount: u32 = 0,
transforms: [MAX_ENTITY]TransformComponent = undefined,
movements: [MAX_ENTITY]MovementComponent = undefined,
textures: [MAX_ENTITY]TextureComponent = undefined,
times: [MAX_ENTITY]TimeComponent = undefined,
collisions: [MAX_ENTITY]CollisionComponent = undefined,

player: Entity = undefined,
debug: Debug = Debug{},

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

pub fn getAllComponents(self: *@This(), comptime T: type) []T {
    const selfFields = @typeInfo(@This()).Struct.fields;

    inline for (selfFields) |f| {
        const fieldTypeInfo = @typeInfo(f.type);
        if (fieldTypeInfo == .Array) {
            if (fieldTypeInfo.Array.child == T) {
                return &@field(self, f.name);
            }
        }
    }
}

pub fn createEntity(self: *@This(), components: anytype) u32 {
    const newEntityId = self.entityCount;
    if (self.entityCount < MAX_ENTITY - 1) {
        self.entityCount = newEntityId + 1;
    } else {
        std.log.err("Overflowed entities", .{});
    }

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
    MovementSystem.run(self, &self.transforms, &self.movements, &self.collisions);
    RenderSystem.run(self, &self.transforms, &self.textures, &self.collisions);
}
