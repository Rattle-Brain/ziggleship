const std = @import("std");
const gpa = @import("std").heap.page_allocator;
const print = std.debug.print;

pub const dimensions = struct { rows: usize, cols: usize };

pub const Cell = enum(u8) {
    Empty,
    Ship,
    Hit,
    Miss,
};

var Board: []Cell = undefined;

fn cell_to_str(c: Cell) u8 {
    return switch (c) {
        .Empty => ' ',
        .Ship => 'S',
        .Hit => 'X',
        .Miss => '·',
    };
}

// Initialize the board just with dots. It stores the info as a 1D array
pub fn initBoard(dims: dimensions) ![]Cell {
    Board = try gpa.alloc(Cell, dims.rows * dims.cols);
    @memset(Board, Cell.Empty);
    return Board;
}

pub fn getBoard() []Cell {
    return Board;
}

// Print the board on the screen
pub fn printBoard(board: []Cell, dims: dimensions) void {
    var letter: u8 = 'a';
    var counter: u64 = dims.rows;

    // Print letter
    for (0..dims.cols) |_| {
        print("  {c} ", .{letter});
        letter = letter + 0x01;
    }

    print("\n", .{});

    // Print the top line:
    print_top(dims);

    for (0..dims.cols * dims.rows) |i| {
        print("│ {c} ", .{cell_to_str(board[i])});

        // Print mid separator line
        if ((i + 1) % dims.cols == 0) {
            print("│ {d}\n", .{counter});
            if ((i / dims.cols) == dims.rows - 1) {
                continue;
            }
            // Print middle line
            print_mid(dims);
            counter = counter - 1;
        }
    }

    // Print bottom line
    print_bot(dims);
}

// Prints the top-most line of the board
fn print_top(dims: dimensions) void {
    for (0..dims.cols + 1) |i| {
        if (i == 0) {
            print("┌─", .{});
        } else if (i == dims.cols) {
            print("──┐\n", .{});
        } else {
            print("──┬─", .{});
        }
    }
}

// Prints a middle line in between cell rows
fn print_mid(dims: dimensions) void {
    for (0..dims.cols + 1) |i| {
        if (i == 0) {
            print("├─", .{});
        } else if (i == dims.cols) {
            print("──┤\n", .{});
        } else {
            print("──┼─", .{});
        }
    }
}

// Prints the bottom-most line of the board
fn print_bot(dims: dimensions) void {
    for (0..dims.cols + 1) |i| {
        if (i == 0) {
            print("└─", .{});
        } else if (i == dims.cols) {
            print("──┘\n", .{});
        } else {
            print("──┴─", .{});
        }
    }
}
