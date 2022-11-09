import Foundation

while true {
    print("\u{001B}[2J")
    print("Welcome to Mineswifter!")
    print("If you want to exit, type 'exit' at any point of time.")
    print("Please enter the level (default is easy): (easy, medium, hard, custom)")
    print("  Easy   - 9x9 board with 10 mines")
    print("  Medium - 16x16 board with 40 mines")
    print("  Hard   - 30x16 board with 99 mines")
    print("  Custom - You specify the board size and mine count")
    let level = readLine()!.lowercased()
    if level == "exit" {
        break
    }
    var width = 0
    var height = 0
    var mineCount = 0
    switch level {
    case "medium":
        width = 16
        height = 16
        mineCount = 40
        break
    case "hard":
        width = 30
        height = 16
        mineCount = 99
        break
    case "custom":
        print("Enter the width of the board: ")
        width = Int(readLine()!)!
        print("Enter the height of the board: ")
        height = Int(readLine()!)!
        print("Enter the number of mines: ")
        mineCount = Int(readLine()!)!
        break
    default:
        width = 9
        height = 9
        mineCount = 10
        break
    }
    let game = Game(width: width, height: height, mineCount: mineCount)
    while !game.isOver {
        print("\u{001B}[2J")
        print("Mineswifter")
        game.printBoard()
        print("Enter the coordinates of the slot you want to reveal: ")
        let input = readLine()!
        if input == "exit" {
            break
        }
        let coords = input.split(separator: " ").map { Int($0)! }
        game.reveal(x: coords[1], y: coords[0])
        game.checkWin()

        if (game.isOver) {
            print("\u{001B}[2J")
            print("Mineswifter")
            game.printBoard()
            print("Time Elapsed: \(round((game.startTime.timeIntervalSinceNow * -1) * 100) / 100.0) seconds")
            if game.isWon! {
                print("You won!")
            } else {
                print("You lost!")
            }
            print("Press enter to continue...")
            let _ = readLine()
            break
        }
    }
}
