import XCTest

#if !canImport(ObjectiveC)
func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ScheduledNotificationsViewControllerTests.allTests),
    ]
}
#endif
