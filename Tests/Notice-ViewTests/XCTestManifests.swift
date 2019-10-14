import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(Notice_ViewTests.allTests),
    ]
}
#endif
