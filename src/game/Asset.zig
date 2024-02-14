const std = @import("std");
const c = @cImport(@cInclude("raylib.h"));

const Allocator = std.mem.Allocator;

name: []const u8,
data: c.Texture,
id: u8 = 0,

const Asset = @This();

const mb = 1024 * 1024;

pub fn load_asset(file_path: []const u8) Asset {
    const texture = c.LoadTexture(file_path.ptr);
    const asset: Asset = .{
        .name = file_path,
        .data = texture,
    };
    return asset;
}

pub fn load_all_assets(allocator: Allocator) std.ArrayList(Asset) {
    const exe_folder_path = std.fs.selfExeDirPathAlloc(allocator) catch unreachable;
    const exe_folder = std.fs.openDirAbsolute(exe_folder_path, .{}) catch unreachable;
    const assets_folder = exe_folder.openDir("assets", .{ .iterate = true, .access_sub_paths = true }) catch unreachable;

    var assets = std.ArrayList(Asset).init(allocator);
    const asset_folder_name = assets_folder.realpathAlloc(allocator, ".") catch unreachable;

    var it = assets_folder.iterate();
    while (it.next() catch unreachable) |*entry| {
        if (entry.kind == .file) {
            const file_path = std.mem.concat(allocator, u8, &.{ asset_folder_name, "/", entry.name, &.{0} }) catch unreachable;
            var asset = load_asset(file_path);
            asset.id = @as(u8, @intCast(assets.items.len + 1));
            assets.append(asset) catch unreachable;
        }
    }

    std.log.info("{} Assets have been loaded", .{assets.items.len});
    return assets;
}
