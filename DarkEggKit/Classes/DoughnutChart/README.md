# DarkEggKit/DoughnutChart

## Draw doughnut chart for data

### Installation and Import

* **Installation**
```ruby
pod 'DarkEggKit/DoughnutChart'
```

* **Import**

```Swift
import DarkEggKit
```

### How to use

* **Add in storyboard**

Is child class of UIView, is @IBDesignable.
Add a UIView in storyboard, and set the Class to ```DoughnutChart```

```Swift
@IBOutlet var dountChart: DoughnutChart!
```

* **Set the data**

```Swift
var data: DoughnutChartData = DoughnutChartData()
data.maxValue = 100.0
data.arcs.append(DoughnutChartArc(value: 45, color: .systemPink))
data.arcs.append(DoughnutChartArc(value: 35, color: .systemOrange))
data.arcs.append(DoughnutChartArc(value: 10, color: .systemGray))
self.dountChart.data = data
```

* **Display**

```Swift
self.dountChart.showChart(animated: true, duration: 1.0)
```

### Some hits

* If all the value in data.arcs if more then data.maxValue, maxValue will be sum of all value in data.arcs.
In this case, the doughnut is always full.
