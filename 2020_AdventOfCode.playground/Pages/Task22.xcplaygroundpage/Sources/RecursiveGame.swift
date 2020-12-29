import Foundation

// MARK:- Part 1
struct Player {
    var hand: [Int]
    var previousHandsHashes = [Int]()
    var cardsCount: Int {
        hand.count
    }
    var handStringified: String {
        hand.map{ String($0) }.joined(separator: ", ")
    }
    var score: Int {
        hand.reversed().enumerated().map {
            ($0 + 1) * $1
        }.reduce(0, +)
    }
}

public class Game {
    private var players: (first: Player, second: Player)
    private var roundCount = 1

    private func playRound() {
        print("-- Round \(roundCount) --")
        roundCount += 1
        print("Player 1's deck: \(players.first.handStringified)")
        print("Player 2's deck: \(players.second.handStringified)")

        let firstCard = players.first.hand.removeFirst()
        let secondCard = players.second.hand.removeFirst()
        print("Player 1 plays: \(firstCard)")
        print("Player 2 plays: \(secondCard)")

        if firstCard < secondCard {
            players.second.hand.append(contentsOf: [firstCard, secondCard].sorted(by: { $0 > $1 }))
            print("Player 2 wins the round!")
        } else {
            players.first.hand.append(contentsOf: [firstCard, secondCard].sorted(by: { $0 > $1 }))
            print("Player 1 wins the round!")
        }
        print("")
    }

    public func playGame() -> Int {
        while !isFinished {
            playRound()
        }
        print("== Post-game results ==")
        print("Player 1's deck: \(players.first.handStringified)")
        print("Player 2's deck: \(players.second.handStringified)")

        print("\n== Score ==")
        let score = players.first.cardsCount > 0 ? players.first.score : players.second.score
        print("Player \(players.first.cardsCount > 0 ? 1 : 2) wins with score: \(score)!")
        return score
    }

    private var isFinished: Bool {
        players.first.cardsCount == 0 || players.second.cardsCount == 0
    }

    public init(first: [Int], second: [Int]) {
        players.first = Player(hand: first)
        players.second = Player(hand: second)
    }
}

//let game = Game(first: first, second: second)
//let answer = game.playGame()
//print("The answer is \(answer)")


// MARK:- Part 2
extension Player {
    mutating public func matchesPreviousHands() -> Bool {
        let hash = hand.hashValue
        if previousHandsHashes.contains(hash) {
            return true
        }
        previousHandsHashes.append(hash)
        return false
    }

}

public struct RecursiveGame {
    private var players: (first: Player, second: Player)
    private var roundCount = 1
    static private(set) var gameCount = 1
    private var id = 1

    public enum PlayerOrder {
        case first, second
        var description: String {
            self == .first ? "1" : "2"
        }
    }

    public enum EndGameError: Error {
        case infiniteLoop
    }

    mutating private func playRound() throws -> PlayerOrder {
        //print("\n-- Round \(roundCount) (Game \(id)) --")
        //print("Player 1's deck: \(players.first.handStringified)")
        //print("Player 2's deck: \(players.second.handStringified)")

        if players.first.matchesPreviousHands() || players.second.matchesPreviousHands() {
            throw EndGameError.infiniteLoop
        }

        let firstCard = players.first.hand.removeFirst()
        let secondCard = players.second.hand.removeFirst()
        //print("Player 1 plays: \(firstCard)")
        //print("Player 2 plays: \(secondCard)")

        var winner: PlayerOrder?
        if firstCard <= players.first.hand.count && secondCard <= players.second.hand.count {
            //print("Playing a sub-game to determine the winner...\n")
            // recursive here
            let newFirstHand = Array(players.first.hand[..<firstCard])
            let newSecondHand = Array(players.second.hand[..<secondCard])
            var recursiveGame = RecursiveGame(first: newFirstHand, second: newSecondHand)
            RecursiveGame.gameCount += 1
            recursiveGame.id = RecursiveGame.gameCount
            winner = recursiveGame.playGame().0
            //print("\n...anyway, back to game \(id).")
        }
        if winner == nil {
            winner = firstCard < secondCard ? .second : .first
        }
        if winner == .first {
            players.first.hand.append(contentsOf: [firstCard, secondCard])
        }
        if winner == .second {
            players.second.hand.append(contentsOf: [secondCard, firstCard])
        }
        //print("Player \(winner!.description) wins round \(roundCount) of game \(id)!")
        roundCount += 1
        return winner!
    }

    mutating public func playGame() -> (PlayerOrder, Int) {
        //print("=== Game \(id) ===")
        var winnerOpt: PlayerOrder?
        do {
            while !isFinished {
                winnerOpt = try playRound()
            }
        } catch EndGameError.infiniteLoop {
            //print("Infinite Loop win!")
            winnerOpt = .first
        } catch {
            fatalError()
        }
        guard let winner = winnerOpt else {
            fatalError()
        }
        let score = winner == .first ? players.first.score : players.second.score
        //print("The winner of game \(id) is player \(winner.description)!")
        if id == 1 {
            print("\n\n== Post-game results ==")
            print("Player 1's deck: \(players.first.handStringified)")
            print("Player 2's deck: \(players.second.handStringified)")
            print("\n== Score ==")
            print("Player \(players.first.cardsCount > 0 ? 1 : 2) wins with score: \(score)!")
        }
        return (winner, score)
    }

    private var isFinished: Bool {
        players.first.cardsCount == 0 || players.second.cardsCount == 0
    }

    public init(first: [Int], second: [Int]) {
        players.first = Player(hand: first)
        players.second = Player(hand: second)
    }
}
