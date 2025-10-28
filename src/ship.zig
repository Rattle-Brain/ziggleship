const boardModule = @import("board.zig");
const DefaultPrng = @import("std").Random.DefaultPrng;
const std = @import("std");

const Ship = struct {
    size: u8,
    rotation: bool      // false=horizontal, true=vertical
};

fn putShip(board: []boardModule.Cell, dims: boardModule.dimensions, ship: Ship) void {
    var initialRow: u8 = randomize();
    var initialCol: u8 = randomize();
    while (true) {
        if(ship.rotation){
            if(initialPosition + ship.size >= dims.rows){
                initialRow = randomize();
                initialCol = randomize();
            } else {
                break;
            }
        } else {
            if(initialPosition + ship.size >= dims.cols){
                initialRow = randomize();
                initialCol = randomize();
            } else {
                break;
            }
        }
    }

    if(ship.rotation){
        for(0..ship.size) |i| {
            board[i] = boardModule.Cell.Ship;
        }
    }
     

}
 
fn checkAvailability() void {
    
}

fn randomize() u8 {
    var prng = DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        try std.posix.getrandom(std.mem.asBytes(&seed));
        break :blk seed;
    });

    var rand = prng.random();

    return rand.int(u8);
}
