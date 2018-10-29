
import Foundation
import MapKit


private let _ModelSingletonSharedInstance = lsSearchState()
open class lsSearchState {
    open class var sharedInstance : lsSearchState {
        return _ModelSingletonSharedInstance
    }
    
    var searchItems: [MKLocalSearchCompletion] = []
}
