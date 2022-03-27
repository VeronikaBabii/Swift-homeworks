import Vapor

func routes(_ app: Application) throws {

    // 1 - simple
    app.post("wordcount", "simple") { req -> [String: Int] in
        let words = try req.content.get([String].self, at: "words")
        let coresNum = try req.content.get(Int.self, at: "cores")
        
        // 1 - split
        let splittedArr = words.split(into: coresNum)

        // 2 - map
        var tuplesArr = [[(String, Int)]]()
        for arr in splittedArr {
            var tempArr = [(String, Int)]()
            for elem in arr {
                let tuple = (elem, 1)
                tempArr.append(tuple)
            }
            tuplesArr.append(tempArr)
        }

        // 3 - sort
        var resDict = [String: [(String, Int)]]()
        for arr in tuplesArr {
            for tuple in arr {
                resDict[tuple.0, default: []].append(tuple)
            }
        }
        let sortedTuplesArr = Array(resDict.values)

        // 4 - reduce
        var tuples = [(String, Int)]()
        for arr in sortedTuplesArr {
            var elemCount = 0
            var elemName = String()
            for tuple in arr {
                elemCount += 1
                elemName = tuple.0
            }
            tuples.append((elemName, elemCount))
        }

        // 5 - array of tuples to dict
        var dict = [String: Int]()
        for tuple in tuples {
            dict[tuple.0] = tuple.1
        }

        return dict
    }

    // 2 - map_reduce
    app.post("wordcount", "map_reduce") { req -> [String: Int] in
        let words = try req.content.get([String].self, at: "words")
        let coresNum = try req.content.get(Int.self, at: "cores")

        // 1 - split
        let splittedArr = words.split(into: coresNum)

        // 2 - map
        var tuplesArr = [[(String, Int)]]()
        splittedArr.forEach { arr in tuplesArr.append(arr.map { ($0, 1) }) }

        // 3 - sort
        var resDict = [String: [(String, Int)]]()
        tuplesArr.forEach { $0.forEach { resDict[$0.0, default: []].append($0) } }
        let sortedTuplesArr = Array(resDict.values)

        // 4 - reduce
        var tuples = [(String, Int)]()
        for arr in sortedTuplesArr {
            let count = arr.reduce(0) { $0 + $1.1 }
            let word = arr[0].0
            tuples.append((word, count))
        }

        // 5 - array of tuples to dict
        var dict = [String: Int]()
        tuples.forEach { dict[$0.0] = $0.1 }

        return dict
    }
}

extension Array {
    func split(into size: Int) -> [SubSequence] {
        var splittedArr: [SubSequence] = .init(repeating: .init(), count: size)
        var i = 0
        
        for elem in self {
            splittedArr[i % size].append(elem)
            i += 1
        }
        return splittedArr
    }
}
