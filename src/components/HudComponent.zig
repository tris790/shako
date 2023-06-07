const AbilityKind = @import("../game/Ability.zig").AbilityKind;

selectedHotbarIndex: u8 = 0,
hotbarItems: [3]AbilityKind = [_]AbilityKind{ AbilityKind.ScatterShot, AbilityKind.MassiveShot, AbilityKind.Dash },
