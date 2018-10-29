import UIKit

class lsSearchResultsTable: UITableViewController {
    var lsData = lsModel.sharedInstance
    var lsSearch = lsSearchState.sharedInstance
    
    var delegate: lsLocationSelectDelegate! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lsSearch.searchItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: "searchCell") as? searchCell
        
        if !(cell != nil) {
            cell = searchCell(style: UITableViewCellStyle.value1, reuseIdentifier: "searchCell")
        }
        cell!.locationLabel.text = lsSearch.searchItems[indexPath.row].title
        
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.selectLocation(locationTitle: lsSearch.searchItems[indexPath.row].title)        
    }
}

class searchCell: UITableViewCell {
    @IBOutlet weak var locationLabel: UILabel!    
}
