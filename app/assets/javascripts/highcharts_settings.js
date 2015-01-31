$(document).ready(function(){
  Highcharts.setOptions({
    global: {
      timezoneOffset: (new Date()).getTimezoneOffset()
    },
    lang: {
      rangeSelectorFrom: "起始时间",
      rangeSelectorTo: "至",
      rangeSelectorZoom: ""
    }
  });
})
