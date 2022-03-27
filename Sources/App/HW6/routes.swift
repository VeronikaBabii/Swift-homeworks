import Vapor

@available(macOS 12.0.0, *)
func routes(_ app: Application) throws {
    
    app.get("weather_advice") { req -> AdviceDTO in
        let name = try req.content.get(String.self, at: "city")
        let dateStr = try req.content.get(String.self, at: "date")
        
        let manager = AdviceManager()
        let date = try manager.getDate(from: dateStr)

        async let advice = try manager.getAdvice(for: name, on: date)
        return try await advice
    }
}
