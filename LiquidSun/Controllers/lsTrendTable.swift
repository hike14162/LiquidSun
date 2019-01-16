
import UIKit

class lsTrendTable: UITableViewController {
    // MARK: - State singleton
    var lsData = lsModel.sharedInstance
    
    // MARK: -  UITableViewController overrides
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lsData.weatherDays.count - 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 26
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let rect = CGRect(x: 5, y: 5, width: 275, height: 22)
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
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 377, height: 60))
        let image = UIImage(named: "pbds")
        
        let imageView = UIImageView(image: image)
        imageView.bounds = CGRect(x: 0, y: 0, width: 188, height: 30)
        imageView.frame = CGRect(x: 10, y: 10, width: 188, height: 30)
        footerView.addSubview(imageView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(darkSkyTap(_:)))
        footerView.addGestureRecognizer(tap)
        
        
        return footerView
    }
    
    @objc func darkSkyTap(_ sender: UITapGestureRecognizer) {
        if let url = URL(string: "https://darksky.net/poweredby/") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "trendCell") as? trendCell
        if (cell == nil) {
            cell = trendCell(style: UITableViewCellStyle.value1, reuseIdentifier: "trendCell")
        }
        
        //Set the cell values
        if let currCell = cell {
            if ((indexPath.row+1) <= lsData.weatherDays.count) {
                currCell.trendDateLabel.text = "\(lsHelper.DateToYearString(lsData.weatherDays[indexPath.row+1].time))"
                if (lsData.weatherDays[indexPath.row+1].temperature < lsData.weatherDays[0].temperature) {
                    currCell.tempLabel.textColor = lsHelper.lightBlueColor()
                } else if (lsData.weatherDays[indexPath.row+1].temperature > lsData.weatherDays[0].temperature) {
                    currCell.tempLabel.textColor =  lsHelper.redColor()
                } else if (lsData.weatherDays[indexPath.row+1].temperature == lsData.weatherDays[0].temperature) {
                    currCell.tempLabel.textColor = .white
                }
                
                currCell.tempLabel.text = "\(lsHelper.doubleToString(lsData.weatherDays[indexPath.row+1].temperature,decimalPlaces: 1))\u{00B0}"
                currCell.summaryTempLabel.text = "\(lsData.weatherDays[indexPath.row+1].summary)"
                currCell.humidityLabel.text = "\(lsHelper.doubleToString(lsData.weatherDays[indexPath.row+1].humidity*100,decimalPlaces: 1))%"
                currCell.windLabel.text = "\(lsHelper.doubleToString(lsData.weatherDays[indexPath.row+1].windSpeed,decimalPlaces: 1)) mph"
                currCell.gustsLabel.text = "\(lsHelper.doubleToString(lsData.weatherDays[indexPath.row+1].windGust,decimalPlaces: 1)) mph"
                currCell.visibilityLabel.text = "\(lsHelper.doubleToString(lsData.weatherDays[indexPath.row+1].visibility,decimalPlaces: 0))mi"
                currCell.feltLike.text = "\(lsHelper.doubleToString(lsData.weatherDays[indexPath.row+1].apparentTemperature,decimalPlaces: 1))\u{00B0}"
                currCell.dewPoint.text = "\(lsHelper.doubleToString(lsData.weatherDays[indexPath.row+1].dewPoint,decimalPlaces: 1))\u{00B0}"
                currCell.cloudCover.text = "\(lsHelper.doubleToString(lsData.weatherDays[indexPath.row+1].cloudCover*100,decimalPlaces: 1))%"
                
                if (lsData.weatherDays[indexPath.row+1].icon == "clear-day") {
                    currCell.iconImage.image = UIImage(named: "clear-day")
                }
                else if (lsData.weatherDays[indexPath.row+1].icon == "clear-night") {
                    currCell.iconImage.image = UIImage(named: "clear-night")
                }
                else if (lsData.weatherDays[indexPath.row+1].icon == "partly-cloudy-day") {
                    currCell.iconImage.image = UIImage(named: "partly-cloudy-day")
                }
                else if (lsData.weatherDays[indexPath.row+1].icon == "partly-cloudy-night") {
                    currCell.iconImage.image = UIImage(named: "partly-cloudy-night")
                }
                else if (lsData.weatherDays[indexPath.row+1].icon == "rain") {
                    currCell.iconImage.image = UIImage(named: "rain")
                }
                else if (lsData.weatherDays[indexPath.row+1].icon == "sleet") {
                    currCell.iconImage.image = UIImage(named: "sleet")
                }
                else if (lsData.weatherDays[indexPath.row+1].icon == "snow") {
                    currCell.iconImage.image = UIImage(named: "snow")
                }
                else if (lsData.weatherDays[indexPath.row+1].icon == "wind") {
                    currCell.iconImage.image = UIImage(named: "wind")
                }
                else if (lsData.weatherDays[indexPath.row+1].icon == "cloudy") {
                    currCell.iconImage.image = UIImage(named: "cloudy")
                }
                else if (lsData.weatherDays[indexPath.row+1].icon == "fog") {
                    currCell.iconImage.image = UIImage(named: "fog")
                }
                else {
                    
                }
            }
            
            if UIScreen.main.nativeBounds.width < 700 {
                currCell.feltLikeLeadingEdge.constant = 100
                currCell.windLeadingEdge.constant = 60
                currCell.dewPointLeadingEdge.constant = 60
                currCell.visibilityLeadingEdge.constant = 60
            }
        }
        return cell ?? UITableViewCell()
    }

}

class trendCell: UITableViewCell {
    // MARK: - View Outlets
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
