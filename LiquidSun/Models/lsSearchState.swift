
import MapKit

private let _ModelSingletonSharedInstance = lsSearchState()
public class lsSearchState {
    public class var sharedInstance : lsSearchState {
        return _ModelSingletonSharedInstance
    }
    
    var searchItems: [MKLocalSearchCompletion] = []
}
