window.display_rate_chart = function(rates) {
  var dates = rates[0],
      rate_arr = rates[1];
  var chart = $(".hight-chart .rate").highcharts("StockChart", {
    title: {
      text: "浦发银行 外汇牌价(美元)",
      x: -20
    },
    rangeSelector: {
      selected: 1
    },
    xAxis: {
      labels: {
        enabled: false
      }
    },
    yAxis : {
      title: {
        enabled: false,
        text: "rate"
      }
    },
    navigator : {
      enabled : false
    },
    series: [{
      name: "rate",
      data: rates
    }],
    exporting: { enabled: false },
    credits: { enabled: false }
  });
}
