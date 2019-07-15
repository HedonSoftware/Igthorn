window.renderChart = (labels, symbol, data) => {
    if(["complete", "loaded", "interactive"].indexOf(document.readyState) >= 0){
        doRender(labels, symbol, data)
    } else {
        document.addEventListener("DOMContentLoaded", () => doRender(labels, symbol, data))
    }
}

let doRender = (labels, symbol, data) => {

    var chartData = {
        labels: labels,
        datasets: [{
            label: symbol,
            backgroundColor: 'rgb(255, 99, 132)',
            borderColor: 'rgb(255, 99, 132)',
            data: data,
            fill: false
        }]
    }

    var config = {
        type: 'line',
        data: chartData,
        options: {
            animation: false,
            responsive: false,
            tooltips: {
                mode: 'index',
                intersect: false,
            },
            scales: {
                xAxes: [{
                    display: true,
                    scaleLabel: {
                        display: true,
                        labelString: 'Time'
                    }
                }],
                yAxes: [{
                    display: true,
                    scaleLabel: {
                        display: true,
                        labelString: 'Price'
                    }
                }]
            }
        }
    }

    if (window.chart !== undefined) {
        window.chart.data = chartData
        window.chart.update()
        return
    }

    var ctx = document.getElementById('lineChart')
    window.chart = new Chart(ctx, config)
}