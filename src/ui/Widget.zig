const Self = @This();

// tree links
first: *Self = undefined,
last: *Self = undefined,
next: *Self = undefined,
prev: *Self = undefined,
parent: *Self = undefined,

// hash links
hash_next: *Self = undefined,
hash_prev: *Self = undefined,

flags: WidgetFlags,
text: [:0]const u8 = undefined,
// key+generation info
//UI_Key key;
//U64 last_frame_touched_index;

// ...

pub const WidgetFlags = packed struct {
    border: bool = false,
    text: bool = false,
    clickable: bool = false,
};
