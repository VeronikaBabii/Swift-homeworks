import Vapor

func routes(_ app: Application) throws {
   
    // 1: Add person to vaccination registry queue.
    app.post("user") { req -> Int in
        let person = try req.content.get(Person.self, at: "person")
        let success = Manager.shared.addPerson(person)
        return success ? 200 : 400
    }

    // 2: Get all people from vaccination registry queue.
    app.get("user") { req -> [Person] in
        return Manager.shared.getAllPeople()
    }
}
