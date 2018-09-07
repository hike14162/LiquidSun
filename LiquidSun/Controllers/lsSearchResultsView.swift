import UIKit
import MapKit

class lsSearchResultsView: UIViewController, MKLocalSearchCompleterDelegate, UISearchBarDelegate, lsLocationSelectDelegate {
    @IBOutlet var searchTableController: lsSearchResultsTable!    
    @IBOutlet weak var sBar: UISearchBar!
    @IBOutlet weak var searchTable: UITableView!

    var lsData = lsModel.sharedInstance
    let searchCompleter: MKLocalSearchCompleter = MKLocalSearchCompleter()
    var delegate: lsSearchDelegate! = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSize(width: 350.0, height: 450.0);
        if !(lsHelper.isiPad()) {
            let cancelButton: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action:  #selector(self.cancelBtnTap(_:)))
            cancelButton.tintColor = .white
            navigationItem.leftBarButtonItems = [cancelButton]
        } else {
            self.navigationController?.navigationBar.barTintColor = UIColor.groupTableViewBackground
            self.navigationController?.navigationBar.titleTextAttributes = (lsHelper.getTitleBarAttributes(light: true) as! [NSAttributedStringKey : Any])

        }

        sBar.becomeFirstResponder()
        searchCompleter.delegate = self
        searchCompleter.filterType = .locationsAndQueries
        searchTableController.delegate = self
    }
    
    @objc func cancelBtnTap(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        lsData.searchItems = []
        for item in completer.results {
            if item.subtitle.count == 0 {
                lsData.searchItems.append(item)
            }
        }
        searchTable.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        lsData.searchItems = []
        searchBar.text = ""
        searchTable.reloadData()
    }
    
    func selectLocation(locationTitle: String) {
        lsData.inSearchMode = true
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationTitle)
        {(placemarks, error) in
            if (error != nil) {
                return
            }
            
            if (placemarks?.count)! > 0 {
                let pm = placemarks![0] as CLPlacemark
                
                let def = CLLocationDegrees()
                let long = "\(pm.location?.coordinate.longitude ?? def)"
                let lat = "\(pm.location?.coordinate.latitude ?? def)"
                
                self.delegate.searchLocationSelected(longitude: long, latitude: lat, city: pm.locality ?? "", state: pm.administrativeArea ?? "")
            } else {
                print("Problem with the data received from geocoder")
            }
            self.lsData.searchItems = []
            self.dismiss(animated: true, completion: nil)
        }
    }
}
