// Bachelor of Software Engineering
// Media Design School
// Auckland
// New Zealand
// 
// (c) 2021 Media Design School
//
// File Name   : main.swift
// Description : Sudoku Solver main source file
// Author      : Nerys Thamm
// Mail        : nerys.thamm@mds.ac.nz


//The closest Swift will let me get to a #define
let MAX_BOARD_LENGTH = 8

//Sudoku board class to make working with 2d array a little easier
class Board {
    var m_numGrid: [[Int]] = [[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]]
    init(){

    }
    init(copy: Board){ //This is a copy constructor
        for y in 0...MAX_BOARD_LENGTH {
            for x in 0...MAX_BOARD_LENGTH {
                m_numGrid[x][y] = copy.m_numGrid[x][y]
            }
        }
    }


}

//Reads User input to get a board
func ReadBoard() -> Board {
    let board = Board()
    for i in 0...8{
        print("Please enter row \(i+1)")
        let input = readLine()
        var count = 0
        for j in input!{
            board.m_numGrid[count][i] = j.wholeNumberValue ?? 0
            count += 1
        }

    }
    return board
}


//Prints a board to the console
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

//************************************************************************************************
//
//  SUDOKU RULES CHECKING
//************************************************************************************************


//Checks if the number is already in the column
func IsInColumn(board: Board, column: Int, number: Int) -> Bool {
    for i in 0...MAX_BOARD_LENGTH {
        if board.m_numGrid[column][i] == number { return true }
    }
    return false
}

//Checks if the number is already in the row
func IsInRow(board: Board, row: Int, number: Int) -> Bool {
    for i in 0...MAX_BOARD_LENGTH {
        if board.m_numGrid[i][row] == number { return true }
    }
    return false
}

//Checks if the number is already in the subgrid
func IsInGrid(gridStartIndexX: Int, gridStartIndexY: Int, number: Int, board: Board) -> Bool {
    for y in gridStartIndexY...gridStartIndexY+2 {
        for x in gridStartIndexX...gridStartIndexX+2 {
            if board.m_numGrid[x][y] == number { return true }
        }
    }
    return false
}

//****************************************************************


//Checks if there are any empty spots left
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


//Recursively solves a Sudoku using a Backtracking algorithm
func RecursiveSolve(board: inout Board, _y: Int, _x: Int) -> Bool {
    
    if _x == 9 { //Recurse to the next row down
        return RecursiveSolve(board: &board, _y: _y + 1, _x: 0)
    }
    
    if _y == 9 { //The program is trying to recurse to a row lower than the last row, which means it solved the whole board
        return true
    }

    
    if board.m_numGrid[_x][_y] != 0 { //If this index is already populated, skip to the next
        return RecursiveSolve(board: &board, _y: _y, _x: _x + 1)
    }

    for num in 1...9 { //For all the possible numbers that can go in a Sudoku...
        
        if !CheckValidPlacement(board: board, _y: _y, _x: _x, number: num) { //Skip this number if it cant be placed here
            continue
        }
        board.m_numGrid[_x][_y] = num //Place it otherwise
        
        if RecursiveSolve(board: &board, _y: _y, _x: _x + 1) { //Recurse a layer deeper to the next spot
            return true //Exit path for the Recursion
        }
        board.m_numGrid[_x][_y] = 0 //If the algorithm couldnt solve the board with this number, undo it
    }
    return false //If no solution could be found return false

    
    
}

//Generates a random board where all clues are valid
func GenBoard() -> Board {
    let board = Board()
    var count = 0
    while(CheckEmpty(board: board) && count < 20) {
        let x = Int.random(in: 0..<9)
        let y = Int.random(in: 0..<9)
        if board.m_numGrid[x][y] != 0 {
            continue
        }
        var temp: Int = 0
        repeat{
            temp = Int.random(in: 1...9)
        }while(!CheckValidPlacement(board: board, _y: y, _x: x, number: temp))
        board.m_numGrid[x][y] = temp
        count += 1
    }
    return board

}

//Generates random boards until it finds one it can solve, then returns it
func GenValidBoard() -> Board {
    var valid = false
    var board: Board?
    while !valid {
        board = GenBoard()
        var temp = Board(copy: board!)
        if RecursiveSolve(board: &temp, _y: 0, _x: 0){
            valid = true
        }
    }
    return board!

}

//****************************************************************
//
//   MAIN 
//****************************************************************
print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")

//Get user Choice
print("Would you like to [M]anually input a board or [G]enerate one? ")
let inp = readLine()
var board: Board?
if inp == "M" || inp == "m" {
    board = ReadBoard()
}
else if inp == "G" || inp == "g" {
    board = GenValidBoard()
}

//Print original and solved Sudokus
PrintBoard(board: board!)
print(RecursiveSolve(board: &board!, _y: 0, _x: 0) ? "Solved!" : "Failed :(")
PrintBoard(board: board!)