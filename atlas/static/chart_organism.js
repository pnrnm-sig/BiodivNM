// ChartJS Graphs
const chartMainColor = getComputedStyle(document.documentElement).getPropertyValue('--main-color');
const chartHoverMainColor = getComputedStyle(document.documentElement).getPropertyValue('--second-color');

const getChartDatas = function (data, key) {
    let values = [];
    for (var i = 0; i < data.length; i++) {
        values.push(data[i][key])
    }
    return values
};

//Circle graph for parts graph
circleChart = function (element, labels, values, colors) {
    return chart = new Chart(element, {
        type: 'pie',
        data: {
            labels: labels,
            datasets: [{
                    label: 'observations',
                    data: values,
                    backgroundColor: colors,
                    hoverBorderWidth : 2,
                    hoverBorderColor : '#191919'
                }]
        },
        options: {
          responsive: true,
          plugins: {
            legend: {
              position: 'top',
              align: 'center',
              labels: { 
                filter: (legendItem, data) => data.datasets[0].data[legendItem.index] != 0 
              },
              onHover: (evt, legendItem) => {
                const activeElement = {
                  datasetIndex: 0,
                  index: legendItem.index
                };
                chart.setActiveElements([activeElement]); // to also show thick border
                chart.tooltip.setActiveElements([activeElement]);
                chart.update();
              }
            },
            tooltip: {
                callbacks:  {
                  label(tooltipItems) {
                    return `${tooltipItems.label} : ${tooltipItems.formattedValue} observations`
                  }
                }
            },
          },
        },
    })
};

var color_tab = [
    '#1e90ff',
    '#8b4513',
    '#006400',
    '#708090',
    '#dcdcdc',
    '#483d8b',
    '#ff00ff',
    '#8b008b',
    '#7fffd4',
    '#ffa500',
    '#ffff00',
    '#7cfc00',
    '#8a2be2',
    '#00ff7f',
    '#dc143c',
    '#00bfff',
    '#ff1493',
    '#f08080',
    '#9acd32',
    '#808000',
    '#f0e68c',
    '#0000ff',
    '#ee82ee',
    '#ff4500',
    '#f3bec3'
  ];

var groupChartElement = document.getElementById('groupChart');
const groupChart = circleChart(groupChartElement, getChartDatas(dataset, 'group2_inpn'), getChartDatas(dataset, 'nb_obs_group'), color_tab);
