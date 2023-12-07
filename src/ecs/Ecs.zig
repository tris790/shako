const std = @import("std");
const Entity = @import("Entity.zig");
const Debug = @import("../game/Debug.zig");
const c = @cImport(@cInclude("raylib.h"));

const MovementComponent = @import("../components/MovementComponent.zig");
const TextureComponent = @import("../components/TextureComponent.zig");
const TransformComponent = @import("../components/TransformComponent.zig");
const TimeComponent = @import("../components/TimeComponent.zig");
const CollisionComponent = @import("../components/CollisionComponent.zig");
const HealthComponent = @import("../components/HealthComponent.zig");
const HudComponent = @import("../components/HudComponent.zig");
const InventoryComponent = @import("../components/InventoryComponent.zig");

const InputSystem = @import("../systems/InputSystem.zig");
const MovementSystem = @import("../systems/MovementSystem.zig");
const RenderSystem = @import("../systems/RenderSystem.zig");
const TimeSystem = @import("../systems/TimeSystem.zig");
const HealthSystem = @import("../systems/HealthSystem.zig");
const CameraSystem = @import("../systems/CameraSystem.zig");

const MAX_ENTITY = 1000;

entityCount: u32 = 0,
transforms: [MAX_ENTITY]TransformComponent = undefined,
movements: [MAX_ENTITY]MovementComponent = undefined,
textures: [MAX_ENTITY]TextureComponent = undefined,
times: [MAX_ENTITY]TimeComponent = undefined,
collisions: [MAX_ENTITY]CollisionComponent = undefined,
healths: [MAX_ENTITY]HealthComponent = undefined,

player: Entity = undefined,
debug: Debug = Debug{},
hud: HudComponent = HudComponent{},
inventory: InventoryComponent = InventoryComponent{},
camera: c.Camera2D = c.Camera2D{
    .target = c.Vector2{ .x = 0.0, .y = 0.0 },
    .offset = c.Vector2{ .x = 0, .y = 0 },
    .rotation = 0.0,
    .zoom = 1.0,
},
fragmentShader: c.Shader = undefined,
deltaTime: f32 = 0,

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
        std.log.err("Overflowed entities, count = {}", .{self.entityCount});
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

pub fn loadShaders(self: *@This()) void {
    self.fragmentShader = c.LoadShader(0, "src/shaders/frag.glsl");
}

pub fn runSystems(self: *@This()) void {
    self.deltaTime += c.GetFrameTime();
    InputSystem.run(self);
    TimeSystem.run(self, self.times[0..self.entityCount], &self.fragmentShader, self.deltaTime);
    MovementSystem.run(self, self.transforms[0..self.entityCount], self.movements[0..self.entityCount], self.collisions[0..self.entityCount]);
    HealthSystem.run(self, self.healths[0..self.entityCount]);
    CameraSystem.run(self, &self.camera, &self.transforms[0].position);

    RenderSystem.run(
        self,
        self.transforms[0..self.entityCount],
        self.textures[0..self.entityCount],
        self.collisions[0..self.entityCount],
        self.healths[0..self.entityCount],
        &self.camera,
        &self.fragmentShader,
        &self.inventory,
    );
}
