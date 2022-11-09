import Foundation

public final class Game {
    public let width: Int
    public let height: Int
    public let mineCount: Int
    public var slots: [[Slot]]
    public var isOver: Bool
    public var isWon: Bool?
    public let startTime: Date
    public var endTime: Date?

    public init(width: Int, height: Int, mineCount: Int) {
        self.width = width
        self.height = height
        self.mineCount = mineCount
        self.slots = [[Slot]]()
        self.isOver = false

        for _ in 0..<height {
            var row = [Slot]()
            for _ in 0..<width {
                row.append(Slot(isMine: false))
            }
            self.slots.append(row)
        }

        for _ in 0..<mineCount {
            let x = Int(arc4random_uniform(UInt32(width)))
            let y = Int(arc4random_uniform(UInt32(height)))
            let slot = self.slots[y][x]
            if slot.isMine {
                continue
            }
            slot.isMine = true
        }
        

        for y in 0..<height {
            for x in 0..<width {
                var mineCount = 0
                for y2 in max(0, y - 1)...min(height - 1, y + 1) {
                    for x2 in max(0, x - 1)...min(width - 1, x + 1) {
                        if self.slots[y2][x2].isMine {
                            mineCount += 1
                        }
                    }
                }
                self.slots[y][x].mineCount = mineCount
            }
        }
        self.startTime = Date()
    }

    public func checkWin() {
        var count = 0
        for y in 0..<height {
            for x in 0..<width {
                if self.slots[y][x].isRevealed {
                    count += 1
                }
            }
        }
        if count == (width * height) - mineCount {
            self.isWon = true
            for i in 0..<self.height {
                for j in 0..<self.width {
                    self.slots[i][j].reveal()
                }
            }
            stop()
        }
    }

    public func reveal(x: Int, y: Int) {
        if self.isOver {
            return
        }

        if x < 0 || x >= self.width || y < 0 || y >= self.height {
            return
        }

        if self.slots[y][x].isRevealed {
            return
        }

        self.slots[y][x].reveal()

        if self.slots[y][x].isMine {
            self.isWon = false
            for i in 0..<self.height {
                for j in 0..<self.width {
                    self.slots[i][j].reveal()
                }
            }
            stop()
            return
        }

        if self.slots[y][x].isBlank() {
            for y2 in max(0, y - 1)...min(height - 1, y + 1) {
                for x2 in max(0, x - 1)...min(width - 1, x + 1) {
                    reveal(x: x2, y: y2)
                }
            }
        }
    }

    public func stop() {
        self.isOver = true
        self.endTime = Date()
    }

    public func printBoard() {
        var cols = "  "
        for x in 0..<width {
            cols += String(x)
            if x < 10 && width >= 10 {
                cols += " "
            }
            cols += " "
        }
        print(cols)
        for y in 0..<height {
            var line = "\(y) "
            if y < 10 && height >= 10 {
                line += " "
            }
            for x in 0..<width {
                line += self.slots[y][x].description() + " "
                if self.width > 10 {
                    line += " "
                }
            }
            print(line)
        }
    }
}
