window.display_rate_chart = function(rates) {
  var dates = rates[0],
      rate_arr = rates[1];
  $.each(rates, function(index, value){
    value[0] = new Date(value[0]).getTime();
  })
  var chart = $(".hight-chart .rate").highcharts("StockChart", {
    title: {
      text: "浦发银行 外汇牌价(美元)",
      x: -20
    },
    rangeSelector: {
      buttons: [{
        type: "24h",
        count: 1,
        text: "24小时"
      }, {
        type: "week",
        count: 1,
        text: "一周"
      }, {
        type: "month",
        count: 1,
        text: "一个月"
      }]
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
