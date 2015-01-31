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
      inputDateFormat: "%Y-%m-%d",
      buttonTheme: {
	width: 54,
	r: 6,
	fill: {
	  fontWeight: "bold",
	  style: {
	    color: "black"
	  }
	},
	states: {
	  hover: {
	    fontWeight: "bold",
	    fill: "#A4A4A4",
	    style: {
	      color: "white"
	    }
	  },
	  select: {
	    fontWeight: "bold",
	    fill: "#A4A4A4",
	    style: {
	      color: "white"
	    }
	  }
	}
      },
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
    tooltip: {
      formatter: function(){
	return "汇率: " + this.y + "<br />更新时间: " + Highcharts.dateFormat("%Y-%m-%d %H:%M", this.x)
      }
    },
    xAxis: {
      labels: {
        enabled: false
      }
    },
    yAxis : {
      labels: {
	align: "left",
      },
      offset: -8,
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
