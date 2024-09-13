const std = @import("std");
const c = @cImport(@cInclude("raylib.h"));

const Widget = @import("Widget.zig");
const Allocator = std.mem.Allocator;

pub fn render() void {
    const widget = Widget{
        .flags = Widget.WidgetFlags{
            .border = true,
            .text = true,
        },
        .text = "Hello world",
    };

    if (widget.flags.border) {
        c.DrawRectangle(0, 0, 300, 100, c.DARKGRAY);
    }

    if (widget.flags.text) {
        c.DrawText(widget.text, 0, 0, 20, c.RED);
    }
}
