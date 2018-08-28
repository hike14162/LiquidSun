
import UIKit

class lsTrendTable: UITableViewController {
    
    var lsData = lsModel.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lsData.weatherDays.count - 1
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let rect = CGRect(x: 5, y: 14, width: 275, height: 22)
        let headerLabel = UILabel(frame: rect)
        
        headerLabel.textColor = UIColor.white
        if lsData.weatherDays.count > 0 {
            headerLabel.text = "Past 5 years at this time"
        }
        else {
            headerLabel.text = ""
        }
        headerLabel.font = UIFont(name: "Apple SD Gothic Neo", size: 18)
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 25))
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: "trendCell") as? trendCell
        
        if !(cell != nil) {
            cell = trendCell(style: UITableViewCellStyle.value1, reuseIdentifier: "trendCell")
        }
        
        //Set the cell values
        if ((indexPath.row+1) <= lsData.weatherDays.count) {
            if lsData.hMode == .days {
                cell?.trendDateLabel.text! = "\(lsHelper.DateToDayString(lsData.weatherDays[indexPath.row+1].time))"
            } else {
                cell?.trendDateLabel.text! = "\(lsHelper.DateToYearString(lsData.weatherDays[indexPath.row+1].time))"
            }
            if (lsData.weatherDays[indexPath.row+1].temperature < lsData.weatherDays[0].temperature) {
                cell?.tempLabel.textColor = lsHelper.lightBlueColor()
            } else if (lsData.weatherDays[indexPath.row+1].temperature > lsData.weatherDays[0].temperature) {
                cell?.tempLabel.textColor =  lsHelper.redColor()
            } else if (lsData.weatherDays[indexPath.row+1].temperature == lsData.weatherDays[0].temperature) {
                cell?.tempLabel.textColor = .black
            }
            cell?.tempLabel.text! = "\(lsHelper.doubleToString(lsData.weatherDays[indexPath.row+1].temperature,decimalPlaces: 1))\u{00B0}"
            cell?.summaryTempLabel.text! = "\(lsData.weatherDays[indexPath.row+1].summary)"
            cell?.humidityLabel.text! = "\(lsHelper.doubleToString(lsData.weatherDays[indexPath.row+1].humidity*100,decimalPlaces: 1))%"
            cell?.windLabel.text! = "\(lsHelper.doubleToString(lsData.weatherDays[indexPath.row+1].windSpeed,decimalPlaces: 1)) mph"
            cell?.gustsLabel.text! = "\(lsHelper.doubleToString(lsData.weatherDays[indexPath.row+1].windGust,decimalPlaces: 1)) mph"
            cell?.visibilityLabel.text! = "\(lsHelper.doubleToString(lsData.weatherDays[indexPath.row+1].visibility,decimalPlaces: 0))mi"
            
            cell?.feltLike.text! = "\(lsHelper.doubleToString(lsData.weatherDays[indexPath.row+1].apparentTemperature,decimalPlaces: 1))\u{00B0}"
            cell?.dewPoint.text! = "\(lsHelper.doubleToString(lsData.weatherDays[indexPath.row+1].dewPoint,decimalPlaces: 1))\u{00B0}"
            cell?.cloudCover.text! = "\(lsHelper.doubleToString(lsData.weatherDays[indexPath.row+1].cloudCover*100,decimalPlaces: 1))%"
            
            if (lsData.weatherDays[indexPath.row+1].icon == "clear-day") {
                cell?.iconImage.image = UIImage(named: "clear-day")
            }
            else if (lsData.weatherDays[indexPath.row+1].icon == "clear-night") {
                cell?.iconImage.image = UIImage(named: "clear-night")
            }
            else if (lsData.weatherDays[indexPath.row+1].icon == "partly-cloudy-day") {
                cell?.iconImage.image = UIImage(named: "partly-cloudy-day")
            }
            else if (lsData.weatherDays[indexPath.row+1].icon == "partly-cloudy-night") {
                cell?.iconImage.image = UIImage(named: "partly-cloudy-night")
            }
            else if (lsData.weatherDays[indexPath.row+1].icon == "rain") {
                cell?.iconImage.image = UIImage(named: "rain")
            }
            else if (lsData.weatherDays[indexPath.row+1].icon == "sleet") {
                cell?.iconImage.image = UIImage(named: "sleet")
            }
            else if (lsData.weatherDays[indexPath.row+1].icon == "snow") {
                cell?.iconImage.image = UIImage(named: "snow")
            }
            else if (lsData.weatherDays[indexPath.row+1].icon == "wind") {
                cell?.iconImage.image = UIImage(named: "wind")
            }
            else if (lsData.weatherDays[indexPath.row+1].icon == "cloudy") {
                cell?.iconImage.image = UIImage(named: "cloudy")
            }
            else if (lsData.weatherDays[indexPath.row+1].icon == "fog") {
                cell?.iconImage.image = UIImage(named: "fog")
            }
            else {
                
            }
        }
        if UIScreen.main.nativeBounds.width < 700 {
            cell?.feltLikeLeadingEdge.constant = 100
            cell?.windLeadingEdge.constant = 60
            cell?.dewPointLeadingEdge.constant = 60
            cell?.visibilityLeadingEdge.constant = 60
        }
        return cell!
    }

}

class trendCell: UITableViewCell {
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var trendDateLabel: UILabel!
    @IBOutlet weak var summaryTempLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var gustsLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!    
    @IBOutlet weak var feltLike: UILabel!
    @IBOutlet weak var dewPoint: UILabel!
    @IBOutlet weak var cloudCover: UILabel!
    @IBOutlet weak var feltLikeLeadingEdge: NSLayoutConstraint!
    @IBOutlet weak var windLeadingEdge: NSLayoutConstraint!
    @IBOutlet weak var dewPointLeadingEdge: NSLayoutConstraint!
    @IBOutlet weak var visibilityLeadingEdge: NSLayoutConstraint!
    
}
