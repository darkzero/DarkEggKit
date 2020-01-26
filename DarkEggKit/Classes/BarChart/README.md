# DarkEggKit/BarChart

## Draw bar chart for data

### Installation and Import

* **Installation**
```ruby
pod 'DarkEggKit/BarChart'
```

* **Import**

```Swift
import DarkEggKit
```

### How to use

* **Add in storyboard**

Is child class of UIView, is @IBDesignable.
Add a UIView in storyboard, and set the Class to ```BarChart```

```Swift
@IBOutlet var barChart: DoughnutChart!
```

* **Set the data**

```Swift
var data: BarChartData = BarChartData()
data.maxValue = 100.0
data.arcs.append(BarChartItem(value: 45, color: .systemPink))
data.arcs.append(BarChartItem(value: 35, color: .systemOrange))
data.arcs.append(BarChartItem(value: 10, color: .systemGray))
self.barChart.data = data
```

* **Display**

```Swift
self.barChart.animationType = .sequence
self.barChart.showChart(animated: true, duration: 1.0)
```
