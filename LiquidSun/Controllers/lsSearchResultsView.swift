import UIKit
import MapKit

class lsSearchResultsView: UIViewController, MKLocalSearchCompleterDelegate, UISearchBarDelegate {
    // MARK: - OView utlets
    @IBOutlet var searchTableController: lsSearchResultsTable!    
    @IBOutlet weak var sBar: UISearchBar!
    @IBOutlet weak var searchTable: UITableView!

    // MARK: - Members
    var lsData = lsModel.sharedInstance
    var lsSearch = lsSearchState.sharedInstance
    var delegate: lsSearchDelegate! = nil

    let searchCompleter: MKLocalSearchCompleter = MKLocalSearchCompleter()

    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        self.preferredContentSize = CGSize(width: 350.0, height: 450.0);
        if !(lsiOSHelper.isiPad()) {
            let cancelButton: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action:  #selector(self.cancelBtnTap(_:)))
            cancelButton.tintColor = .white
            navigationItem.leftBarButtonItems = [cancelButton]
        } else {
            self.navigationController?.navigationBar.barTintColor = UIColor.groupTableViewBackground
            self.navigationController?.navigationBar.titleTextAttributes = (lsiOSHelper.getTitleBarAttributes(light: true) as? [NSAttributedString.Key : Any])

        }

        sBar.becomeFirstResponder()
        searchCompleter.delegate = self
        searchCompleter.filterType = .locationsAndQueries
        searchTableController.delegate = self
    }
    
    @objc private func cancelBtnTap(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    

    // MARK: - UISearchBarDelegate implementation
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        lsSearch.searchItems = []
        searchBar.text = ""
        searchTable.reloadData()
    }

    // MARK: - MKLocalSearchCompleterDelegate implementation
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        lsSearch.searchItems = []
        for item in completer.results {
            if item.subtitle.count == 0 {
                lsSearch.searchItems.append(item)
            }
        }
        searchTable.reloadData()
    }

}

// MARK: - lsLocationSelectDelegate
extension lsSearchResultsView: lsLocationSelectDelegate {
    func selectLocation(locationTitle: String) {
        lsData.inSearchMode = true
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationTitle)
        {(placemarks, error) in
            if (error != nil) {
                return
            }
        
            if let plcMk = placemarks {
                if (plcMk.count) > 0 {
                    let pm = plcMk[0] as CLPlacemark
                    let def = CLLocationDegrees()
                    let long = "\(pm.location?.coordinate.longitude ?? def)"
                    let lat = "\(pm.location?.coordinate.latitude ?? def)"
                    
                    self.delegate.searchLocationSelected(longitude: long, latitude: lat, city: pm.locality ?? "", state: pm.administrativeArea ?? "")
                } else {
                    print("Problem with the data received from geocoder")
                }
            }

            self.lsSearch.searchItems = []
            self.dismiss(animated: true, completion: nil)
        }
    }
}

