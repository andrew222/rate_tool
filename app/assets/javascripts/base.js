window.display_rate_chart = function(rates) {
  var dates = rates[0],
      rate_arr = rates[1];
  var chart = $(".hight-chart .rate").highcharts({
    type: "line",
    title: {
      text: "浦发银行 外汇牌价(美元)",
      x: -20
    },
    xAxis: {
      categories: dates
    },
    yAxis : {
      title: {
        text: "rate"
      },
      plotLines: [{
	value: 0,
	width: 1,
	color: '#808080'
      }]
    },
    series: [{
      name: "rate",
      data: rate_arr
    }]
  });
}
