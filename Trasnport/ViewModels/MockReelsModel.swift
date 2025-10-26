import Foundation

@Observable class MockReelsModel: ObservableObject {
    var stories: [Story]
    
    init() {
        self.stories = [
            Story.story1,
            Story.story2,
            Story.story3,
            Story.story4
        ]
    }
}
