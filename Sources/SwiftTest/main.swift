let MAX_BOARD_LENGTH = 8

class Board {
    var m_numGrid: [[Int]] = [[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]]
    


}
func PrintBoard(board: Board) -> Void {
    var output: String = ""
    for y in 0...MAX_BOARD_LENGTH {
        for x in 0...MAX_BOARD_LENGTH {
            output += String(board.m_numGrid[x][y]) + " "
            
            
        }
        output += "\n"

    }
    print(output)
    return
    
}

func IsInColumn(board: Board, column: Int, number: Int) -> Bool {
    for i in 0...MAX_BOARD_LENGTH {
        if board.m_numGrid[column][i] == number { return true }
    }
    return false
}

func IsInRow(board: Board, row: Int, number: Int) -> Bool {
    for i in 0...MAX_BOARD_LENGTH {
        if board.m_numGrid[i][row] == number { return true }
    }
    return false
}

func IsInGrid(gridStartIndexX: Int, gridStartIndexY: Int, number: Int, board: Board) -> Bool {
    for y in gridStartIndexY...gridStartIndexY+2 {
        for x in gridStartIndexX...gridStartIndexX+2 {
            if board.m_numGrid[x][y] == number { return true }
        }
    }
    return false
}

func CheckEmpty(board: Board) -> Bool {
    for y in 0...MAX_BOARD_LENGTH {
        for x in 0...MAX_BOARD_LENGTH {
            
            if board.m_numGrid[x][y] == 0 {
                return true
            }
            
        }
    }
    return false;
}

//Combines other checking functions to check if the number is valid for that subgrid, row, and column as per rules of Sudoku
func CheckValidPlacement(board: Board, _y: Int, _x: Int, number: Int) -> Bool {
    
    if !(IsInRow(board: board, row: _y, number: number) || IsInColumn(board: board, column: _x, number: number) || IsInGrid(gridStartIndexX: _x - _x % 3, gridStartIndexY: _y - _y % 3, number: number, board: board)){
        return true
    }
    else {
        return false
    }
    
}



func RecursiveSolve(board: inout Board, _y: Int, _x: Int) -> Bool {
    
    if _x == 9 {
        return RecursiveSolve(board: &board, _y: _y + 1, _x: 0)
    }
    
    if _y == 9 {
        return true
    }

    
    if board.m_numGrid[_x][_y] != 0 {
        return RecursiveSolve(board: &board, _y: _y, _x: _x + 1)
    }

    for num in 1...9 {
        
        if !CheckValidPlacement(board: board, _y: _y, _x: _x, number: num) {
            continue
        }
        board.m_numGrid[_x][_y] = num
        
        if RecursiveSolve(board: &board, _y: _y, _x: _x + 1) {
            return true
        }
        board.m_numGrid[_x][_y] = 0
    }
    return false

    
    
}

var board: Board = Board()



let temp: [[Int]] = [[0,0,6,0,4,0,0,9,7],
                    [0,4,0,7,3,0,0,1,0],
                    [0,1,7,0,9,2,0,3,0],
                    [6,0,0,0,7,0,0,8,0],
                    [1,0,5,0,6,0,9,0,3],
                    [0,2,0,0,1,0,0,0,6],
                    [0,5,0,9,8,0,1,6,0],
                    [0,9,0,0,5,6,0,7,0],
                    [8,6,0,0,2,0,3,0,0]]

let solved: [[Int]] = [[8,5,6,2,1,4,7,3,9],
                    [1,9,3,5,7,6,8,4,2],
                    [2,4,7,0,8,3,1,6,5],
                    [4,6,2,7,5,9,3,8,1],
                    [9,3,1,8,6,2,4,5,7],
                    [7,8,5,3,4,1,9,2,6],
                    [6,2,4,1,9,8,5,7,3],
                    [3,7,9,4,2,5,6,1,8],
                    [5,1,8,6,3,7,2,9,4]]


for i in 0...MAX_BOARD_LENGTH {
    for j in 0...MAX_BOARD_LENGTH {
        board.m_numGrid[j][i] = temp[i][j]
        
    }
}
print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")


PrintBoard(board: board)

print(RecursiveSolve(board: &board, _y: 0, _x: 0))


PrintBoard(board: board)