const std = @import("std");
const c = @import("../c.zig");
const Animation = @import("Animation.zig");

const Allocator = std.mem.Allocator;

pub const AssetType = union(enum) {
    none,
    model: c.Model,
    animation: Animation,
};

name: []const u8,
data: AssetType,
id: u8 = 0,

const Asset = @This();

const mb = 1024 * 1024;

pub fn load_model(file_path: []const u8) Asset {
    const data = c.LoadModel(file_path.ptr);
    const asset = Asset{
        .name = file_path,
        .data = AssetType{ .model = data },
    };
    return asset;
}

pub fn load_animation(file_path: []const u8) Asset {
    var animation_count: u32 = 0;
    const data = c.LoadModelAnimations(file_path.ptr, @ptrCast(&animation_count));
    const asset = Asset{
        .name = file_path,
        .data = AssetType{
            .animation = Animation{
                .data = data,
                .animation_count = animation_count,
            },
        },
    };
    return asset;
}

pub fn load_all_assets(allocator: Allocator, useLocalAssets: bool) std.ArrayList(Asset) {
    const exe_folder_path = std.fs.selfExeDirPathAlloc(allocator) catch unreachable;
    const exe_folder = std.fs.openDirAbsolute(exe_folder_path, .{}) catch unreachable;
    const assets_folder = switch (useLocalAssets) {
        true => std.fs.cwd().openDir("assets", .{ .iterate = true, .access_sub_paths = true }) catch unreachable,
        else => exe_folder.openDir("assets", .{ .iterate = true, .access_sub_paths = true }) catch unreachable,
    };

    var assets = std.ArrayList(Asset).init(allocator);
    assets.append(Asset{ .name = "Dummy", .data = AssetType.none }) catch unreachable;
    const asset_folder_name = assets_folder.realpathAlloc(allocator, ".") catch unreachable;

    var it = assets_folder.iterate();
    while (it.next() catch unreachable) |*entry| {
        if (entry.kind == .file) {
            const file_path = std.mem.concat(allocator, u8, &.{ asset_folder_name, "/", entry.name, &.{0} }) catch unreachable;
            if (std.mem.endsWith(u8, entry.name, ".glb")) {
                var model = load_model(file_path);
                model.id = @as(u8, @intCast(assets.items.len));
                assets.append(model) catch unreachable;
                std.log.info("Loaded model id({}): {s}", .{ model.id, model.name });

                var animation = load_animation(file_path);
                animation.id = @as(u8, @intCast(assets.items.len));
                std.log.info("Loaded animations id({}): {s}", .{ animation.id, animation.name });
                assets.append(animation) catch unreachable;
            }
        }
    }

    std.log.info("{} Assets have been loaded", .{assets.items.len - 1});
    return assets;
}
