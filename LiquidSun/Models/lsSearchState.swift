
import MapKit

private let _ModelSingletonSharedInstance = lsSearchState()
public class lsSearchState {
    // MARK: - Singleton method
    public class var sharedInstance : lsSearchState {
        return _ModelSingletonSharedInstance
    }
    
    // MARK: - public members
    var searchItems: [MKLocalSearchCompletion] = []
}
