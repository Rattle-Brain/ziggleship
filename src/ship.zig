const boardModule = @import("board.zig");
const DefaultPrng = @import("std").Random.DefaultPrng;
const std = @import("std");

pub const Ship = struct {
    size: u8,
    rotation: bool      // false=horizontal, true=vertical
};

pub fn putShip(board: [][]boardModule.Cell, dims: boardModule.dimensions, ship: Ship) void {
    var initialRow: u8 = randomize(dims.rows);
    var initialCol: u8 = randomize(dims.cols);
    while (true) {
        if(ship.rotation){
            std.debug.print("Row: {d}\n", .{initialRow});
            std.debug.print("Column: {d}\n\n", .{initialCol});
            // Vertical placement
            if(initialRow + ship.size >= dims.rows){
                initialRow = randomize(dims.rows);
                initialCol = randomize(dims.cols);
            } else {
                if (checkAvailability(initialRow, initialCol, ship, board)){
                    for(0..ship.size) |i| {
                        board[initialRow + i][initialCol] = boardModule.Cell.Ship;
                    }
                    break;
                }
                initialRow = randomize(dims.rows);
                initialCol = randomize(dims.cols);
            }
        } else {
            // Horizontal placement
            if(initialCol + ship.size >= dims.cols){
                initialRow = randomize(dims.rows);
                initialCol = randomize(dims.cols);
            } else {
                if (checkAvailability(initialRow, initialCol, ship, board)){
                    for(0..ship.size) |i| {
                        board[initialRow][initialCol + i] = boardModule.Cell.Ship;
                    }
                    break;
                }
                initialRow = randomize(dims.rows);
                initialCol = randomize(dims.cols);
            }
        }
    }
}
 
fn checkAvailability(initRow:u8, initCol:u8, ship:Ship, board:[][]boardModule.Cell) bool {
    const size: usize = ship.size;
    const rotation: bool = ship.rotation;

    if (rotation) {
        for (0..size) |i| {
            if (board[initRow + i] [initCol] != boardModule.Cell.Empty) {
                return false;
            }
        }
    } else {
        for (0..size) |i| {
            if (board[initRow] [initCol + i] != boardModule.Cell.Empty) {
                return false;
            }
        }
    }
    return true;
}

fn randomize(max: usize) u8 {
    var prng = DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        std.posix.getrandom(std.mem.asBytes(&seed)) catch {
            // Fallback value if function fails.
            seed = 0xDEADBEEFCAFEBABE;
        };
        break :blk seed;
    });

    var rand = prng.random();
    const limited_max: u8 = @intCast(@min(max, std.math.maxInt(u8)));
    return rand.intRangeAtMost(u8, 0, limited_max-1);
}
