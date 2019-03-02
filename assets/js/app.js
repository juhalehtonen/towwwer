// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css";

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html";

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

import * as Plotly from 'plotly.js';

// Add monitors
if (document.getElementById('add_monitor')) {
    let el = document.getElementById('add_monitor');
    el.onclick = function(e){
        e.preventDefault();
        var el = document.getElementById('add_monitor');
        let time = new Date().getTime();
        let template = el.getAttribute('data-template');
        var uniq_template = template.replace(/\[0]/g, `[${time}]`);
        uniq_template = uniq_template.replace(/\[0]/g, `_${time}_`);
        this.insertAdjacentHTML('beforebegin', uniq_template);
    };
}


// PLOTLY
let drawGraphForMonitor = function(monitor_id, element) {
    let url = 'http://localhost:4000/api/v1/monitors/' + monitor_id;
    let perf_xl = [];
    let perf_yl = [];
    let bp_xl = [];
    let bp_yl = [];

    let coordData = {
        time_xl: [],
        perf_yl: [],
        seo_yl: [],
        bp_yl: [],
        acc_yl: []
    };

    let layout = {
        title: "Score over time",
        yaxis: {title: "Score", type: "linear", range: [0, 105],},
        xaxis: {title: "Date", type: "date"}
    };

    let config = {
        displayModeBar: false,
        responsive: true
    };

    Plotly.d3.json(url, function(figure) {
        let data = figure.data.reports;
        for (var key in data) {
            coordData.time_xl.push(data[key]["timestamp"]);
            coordData.perf_yl.push(data[key]["performance"]);
            coordData.seo_yl.push(data[key]["seo"]);
            coordData.bp_yl.push(data[key]["best-practices"]);
            coordData.acc_yl.push(data[key]["accessibility"]);
        }

        let trace_perf = constructTrace("Performance", coordData.time_xl, coordData.perf_yl, "#0074D9");
        let trace_seo = constructTrace("SEO", coordData.time_xl, coordData.seo_yl, "#3D9970");
        let trace_bp = constructTrace("Best Practices", coordData.time_xl, coordData.bp_yl, "#FF851B ");
        let trace_acc = constructTrace("Accessibility", coordData.time_xl, coordData.acc_yl, "#F012BE");

        Plotly.plot(element, [trace_perf, trace_seo, trace_bp, trace_acc], layout, config);
    });
};

let constructTrace = function(name, x, y, color) {
    const trace = {
        type: "scatter",
        mode: "lines+markers",
        name: name,
        x: x,
        y: y,
        line: {color: color, dash: "solid", width: 1},
    };

    return trace;
};

let loopMonitorsForGraphs = function() {
    if (document.getElementsByClassName('js-plotly')) {
        let elements = document.getElementsByClassName('js-plotly');
        for (let element of elements) {
            let id = element.getAttribute('data-monitor-id');
            drawGraphForMonitor(id, element);
        }
    }
};

loopMonitorsForGraphs();

