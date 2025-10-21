const std = @import("std");
const gpa = @import("std").heap.page_allocator;
const print = std.debug.print;

pub const dimensions = struct {
    rows: usize,
    cols: usize
};

const Cell = enum(u8) {
    Empty,
    Ship,
    Hit,
    Miss,
};

fn cell_to_str(c: Cell) u8 {
    return switch (c) {
        .Empty => ' ',
        .Ship  => 'S',
        .Hit   => 'X',
        .Miss  => '·',
    };
}

// Initialize the board just with dots. It stores the info as a 1D array
pub fn initBoard(dims: dimensions) ![]Cell {
    const board: []Cell = try gpa.alloc(Cell, dims.rows * dims.cols);
    @memset(board, Cell.Empty);
    return board;
}

// Print the board on the screen
pub fn printBoard(board: []Cell, dims: dimensions) void {
    var counter: u8 = 1;
    // Print the top line:
    for (0..dims.cols+1) |i|{
        if (i == 0) {
            print("┌─", .{});
        } else if (i == dims.cols) {
            print("──┐\n", .{});
        } else {
            print("──┬─", .{});
        }
    }
    for (0..dims.cols*dims.rows) |i| {
        print("│ {c} ", .{cell_to_str(board[i])});

        // Print mid separator line
        if((i+1) % dims.cols == 0){
            print("│ {d}\n", .{counter});
            if ((i/dims.cols) == dims.rows - 1) {
                continue;
            }
            for (0..dims.cols+1) |j|{
                if (j == 0) {
                    print("├─", .{});
                } else if (j == dims.cols) {
                    print("──┤\n", .{});
                } else {
                    print("──┼─", .{});
                }
            }
            counter = counter + 1;
        }
    }

    // Print bottom line
    for (0..dims.cols+1) |i|{
        if (i == 0) {
            print("└─", .{});
        } else if (i == dims.cols) {
            print("──┘\n", .{});
        } else {
            print("──┴─", .{});
        }
    }
}
