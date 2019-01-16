
import UIKit

private let reuseIdentifier = "forecastCell"

class lsForecastCollection: UICollectionViewController {
    var lsData = lsModel.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if lsData.weatherDays.count > 0 {
            return lsData.weatherDays[0].forecast.count
        } else {
            return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? lsForecastCell
        if let currCell = cell {
            currCell.highTempLabel.textColor = lsHelper.redColor()
            currCell.lowTempLabel.textColor = lsHelper.lightBlueColor()
            
            currCell.dowLabel.text = lsData.weatherDays[0].forecast[indexPath.row].dayOfWeek
            currCell.highTempLabel.text = "\(lsHelper.DoubleToWholeString(value: lsData.weatherDays[0].forecast[indexPath.row].highTemp))\u{00B0}"
            
            currCell.lowTempLabel.text = "\(lsHelper.DoubleToWholeString(value: lsData.weatherDays[0].forecast[indexPath.row].lowTemp))\u{00B0}"
            currCell.precipLabel.text = "\(lsHelper.DoubleToWholeString(value: ((lsData.weatherDays[0].forecast[indexPath.row].percip / 10).rounded() * 10)))%"
            
            if (lsData.weatherDays[0].forecast[indexPath.row].icon == "clear-day") {
                currCell.indImage.image = UIImage(named: "clear-day")
            }
            else if (lsData.weatherDays[0].forecast[indexPath.row].icon == "clear-night") {
                currCell.indImage.image = UIImage(named: "clear-day")
            }
            else if (lsData.weatherDays[0].forecast[indexPath.row].icon == "partly-cloudy-day") {
                currCell.indImage.image = UIImage(named: "partly-cloudy-day")
            }
            else if (lsData.weatherDays[0].forecast[indexPath.row].icon == "partly-cloudy-night") {
                currCell.indImage.image = UIImage(named: "partly-cloudy-day")
            }
            else if (lsData.weatherDays[0].forecast[indexPath.row].icon == "rain") {
                currCell.indImage.image = UIImage(named: "rain")
            }
            else if (lsData.weatherDays[0].forecast[indexPath.row].icon == "sleet") {
                currCell.indImage.image = UIImage(named: "sleet")
            }
            else if (lsData.weatherDays[0].forecast[indexPath.row].icon == "snow") {
                currCell.indImage.image = UIImage(named: "snow")
            }
            else if (lsData.weatherDays[0].forecast[indexPath.row].icon == "wind") {
                currCell.indImage.image = UIImage(named: "wind")
            }
            else if (lsData.weatherDays[0].forecast[indexPath.row].icon == "cloudy") {
                currCell.indImage.image = UIImage(named: "cloudy")
            }
            else if (lsData.weatherDays[0].forecast[indexPath.row].icon == "fog") {
                currCell.indImage.image = UIImage(named: "fog")
            }
            else {
                
            }
        }
        
        return cell ?? UICollectionViewCell()
    }

}


class lsForecastCell: UICollectionViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()

        layer.cornerRadius = 5
        layer.borderWidth = 0.2
        layer.borderColor = UIColor.black.cgColor
    
    }
    
    @IBOutlet weak var indImage: UIImageView!
    @IBOutlet weak var precipLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var dowLabel: UILabel!
}
