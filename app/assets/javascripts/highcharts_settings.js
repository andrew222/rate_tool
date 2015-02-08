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
  toastr.options = {
    "closeButton": true,
    "positionClass": "toast-bottom-right",
    "preventDuplicates": false,
    "showDuration": "300",
    "hideDuration": "1000",
    "timeOut": "5000",
    "extendedTimeOut": "1000",
  }
})
