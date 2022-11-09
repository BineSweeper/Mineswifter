public final class Slot {
    public var isMine: Bool
    public var isRevealed: Bool
    public var mineCount: Int

    public init(isMine: Bool) {
        self.isMine = isMine
        self.isRevealed = false
        self.mineCount = 0
    }

    public func reveal() {
        self.isRevealed = true
    }

    public func isBlank() -> Bool {
        return !isMine && mineCount == 0
    }

    public func description() -> String {
        if !isRevealed {
            return "■"
        }
        if isMine {
            return "X"
        }
        if mineCount == 0 {
            return " "
        }
        return String(mineCount)
    }
}
