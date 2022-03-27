import Vapor

func routes(_ app: Application) throws {

    // MARK: - Data
    
    struct Interest: Content {
        let name: String
    }
    
    struct User: Content {
        let name: String
        var interests = [Interest]()
        var following = [User]()
        var followers = [User]()
    }
    
    var users = [User]()
    var interests = [Interest]()

    // MARK: - Endpoints
    
    // 1: Add user with name.
    app.post("user") { req -> Int in
        let name = try req.content.get(String.self, at: "name")
        
        let user = User(name: name)
        
        if !users.contains(where: { $0.name == name }) {
            users.append(user)
        } else {
            print("User already exists")
            return 400
        }
        
        print("Added new user with the name: \(user.name)")
        print("Users: \(users.map { $0.name })")
        
        return 200
    }

    // 2.1: Add interest with name.
    app.post("interests") { req -> Int in
        let interestName = try req.content.get(String.self, at: "name")
        
        let interest = Interest(name: interestName)
        
        if !interests.contains(where: { $0.name == interestName }) {
            interests.append(interest)
        } else {
            print("Interest already exists")
            return 400
        }
        
        print("Added new interest with the name: \(interest.name)")
        print("Interests after addition: \(interests.map({ $0.name }))")
        
        return 200
    }

    // 2.2: Delete interest with name.
    app.delete("interests") { req -> Int in
        let interestName = try req.content.get(String.self, at: "name")
        
        if !interests.contains(where: { $0.name == interestName }) {
            print("No such interest")
            return 400
        }
        
        interests.removeAll { $0.name == interestName }
        print("Interests after deletion: \(interests.map({ $0.name }))")
        
        // Remove deleted interest from all users.
        for (index, _) in users.enumerated() {
            users[index].interests.removeAll { $0.name == interestName }
        }
        
        users.forEach({ user in
            print(user.name)
            print("Interests: \(user.interests.map { $0.name })")
        })
        
        return 200
    }

    // 3: Add interest with name to the user if interest exists.
    app.post(["user", "interests"]) { req -> Int in
        let interestName = try req.content.get(String.self, at: "interestName")
        let userName = try req.content.get(String.self, at: "userName")
        
        // Check if interest exists.
        if !interests.contains(where: { $0.name == interestName }) {
            print("No such interest")
            return 400
        }
        
        guard let i = users.firstIndex(where: { $0.name == userName }) else {
            print("No such user")
            return 400
        }
        
        if !(users[i].interests.contains(where: { $0.name == interestName })) {
            users[i].interests.append(Interest(name: interestName))
        } else {
            print("User already has this interest")
            return 400
        }
        
        print("Users: \(users.map { $0.name })")
        
        users.forEach({ user in
            print(user.name)
            print("Interests: \(user.interests.map { $0.name })")
        })
        
        return 200
    }

    // 4: Delete interest with name from the user.
    app.delete(["user", "interests"]) { req -> Int in
        let interestName = try req.content.get(String.self, at: "interestName")
        let userName = try req.content.get(String.self, at: "userName")
        
        // Check if interest exists.
        if !interests.contains(where: { $0.name == interestName }) {
            print("Specified interest doesn`t exist in the system")
            return 400
        }
        
        guard let i = users.firstIndex(where: { $0.name == userName }) else {
            print("No such user")
            return 400
        }
        
        if !users[i].interests.contains(where: { $0.name == interestName }) {
            print("User doesn't have this interest")
            return 400
        }
        
        users[i].interests.removeAll { $0.name == interestName }
        
        users.forEach({ user in
            print(user.name)
            print("Interests: \(user.interests.map { $0.name })")
        })
        
        return 200
    }

    // 5.1: Follow user.
    app.post(["user", "follow"]) { req -> Int in
        let currUser = try req.content.get(String.self, at: "currUser")
        let userToFollow = try req.content.get(String.self, at: "userToFollow")
        
        if currUser == userToFollow {
            print("User cannot follow itself")
            return 400
        }
        
        guard let followIndex = users.firstIndex(where: { $0.name == userToFollow }) else {
            print("No user to add follower to")
            return 400
        }
        
        guard let currIndex = users.firstIndex(where: { $0.name == currUser }) else {
            print("No user to add following to")
            return 400
        }
        
        // Add follower.
        if !(users[followIndex].followers.contains(where: { $0.name == userToFollow })) {
            users[followIndex].followers.append(users[currIndex])
        } else {
            print("User already has this follower")
            return 400
        }
        
        // Add following.
        if !(users[currIndex].following.map({ $0.name }).contains(userToFollow)) {
            users[currIndex].following.append(users[followIndex])
        } else {
            print("User already follows this user")
            return 400
        }
        
        users.forEach({ user in
            print(user.name)
            print("Following: \(user.following.map { $0.name })")
            print("Followers: \(user.followers.map { $0.name })")
        })
        
        return 200
    }

    // 5.2: Unfollow user.
    app.post(["user", "unfollow"]) { req -> Int in
        let currUser = try req.content.get(String.self, at: "currUser")
        let userToUnfollow = try req.content.get(String.self, at: "userToUnfollow")
        
        if currUser == userToUnfollow {
            print("User cannot unfollow itself")
            return 400
        }
        
        guard let unfollowIndex = users.firstIndex(where: { $0.name == userToUnfollow }) else {
            print("No user to remove follower from")
            return 400
        }
        
        guard let currIndex = users.firstIndex(where: { $0.name == currUser }) else {
            print("No user to remove following from")
            return 400
        }
        
        if !users[currIndex].following.contains(where: { $0.name == userToUnfollow }) {
            print("User is not following specified user")
            return 400
        }
        
        users[unfollowIndex].followers.removeAll { $0.name == currUser }
        users[currIndex].following.removeAll { $0.name == userToUnfollow }

        users.forEach({ user in
            print(user.name)
            print("Following: \(user.following.map { $0.name })")
            print("Followers: \(user.followers.map { $0.name })")
        })
        
        return 200
    }

    // 6: Get user followings.
    app.get(["user", "following"]) { req -> [String] in
        let userName = try req.content.get(String.self, at: "currUser")
        
        guard let i = users.firstIndex(where: { $0.name == userName }) else {
            print("No such user")
            return []
        }
        
        return users[i].following.map { $0.name }
    }

    // 7: Get list of common following for two users.
    app.get(["user", "common_followings"]) { req -> [String] in
        let user1 = try req.content.get(String.self, at: "user1")
        let user2 = try req.content.get(String.self, at: "user2")
        
        return getCommon(interests: false, of: user1, and: user2)
    }

    // 8: Get list of common interests of two users.
    app.get(["user", "common_interests"]) { req -> [String] in
        let user1 = try req.content.get(String.self, at: "user1")
        let user2 = try req.content.get(String.self, at: "user2")
        
        return getCommon(interests: true, of: user1, and: user2)
    }

    // 9: Get users whom user is not following and has common interests with.
    app.get(["user", "possible_friends"]) { req -> [String] in
        let user = try req.content.get(String.self, at: "user")
        
        var possibleFriends = [String]()
        
        guard let currIndex = users.firstIndex(where: { $0.name == user }) else {
            print("No such user")
            return []
        }
            
        // Get whom user is not following.
        let userFollowings = users[currIndex].following.map { $0.name }
        let allUsers = users.map({ $0.name })
        let userDontFollow = allUsers.filter { !userFollowings.contains($0) }
        
        // Get users with common_interests of user.
        var hasCommonInterestsWith = [String]()
        for user in users {
            if (getCommon(interests: true, of: users[currIndex].name, and: user.name) != []) {
                hasCommonInterestsWith.append(user.name)
            }
        }
        
        possibleFriends = userDontFollow.filter { hasCommonInterestsWith.contains($0) }
            .filter { $0 != user } // Remove current user.
        
        return possibleFriends
    }

    // 10: Get user followings and its interests.
    app.get(["user", "following_interests"]) { req -> [String: [String]] in
        let user = try req.content.get(String.self, at: "user")
        
        var res = [String: [String]]()
        
        guard let currIndex = users.firstIndex(where: { $0.name == user }) else {
            print("No such user")
            return [:]
        }
        
        for user in users[currIndex].following {
            res[user.name] = []
            
            var userInterests = [String]()
            for interest in user.interests {
                userInterests.append(interest.name)
            }
            
            for interest in userInterests {
                res[user.name, default: []].append(interest)
            }
        }
        return res
    }
    
    // MARK: - Helpers
    
    func getCommon(interests: Bool, of user1: String, and user2: String) -> [String] {
        var user1Arr = [String]()
        var user2Arr = [String]()
        
        guard let user1Index = users.firstIndex(where: { $0.name == user1 }) else {
            print("No such user for user1")
            return []
        }
        
        guard let user2Index = users.firstIndex(where: { $0.name == user2 }) else {
            print("No such user for user2")
            return []
        }
        
        if interests {
            user1Arr = users[user1Index].interests.map { $0.name }
            user2Arr = users[user2Index].interests.map { $0.name }
        } else {
            user1Arr = users[user1Index].following.map { $0.name }
            user2Arr = users[user2Index].following.map { $0.name }
        }
        
        let common = user1Arr.filter(user2Arr.contains)
        return common
    }
}
