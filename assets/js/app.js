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
let drawGraphForMonitor = function(monitor_id) {
    if (document.getElementById('plotly')) {
        let plotlyEl = document.getElementById('plotly');
        let url = 'http://localhost:4000/api/v1/monitors/' + monitor_id;
        let xl = [];
        let yl = [];

        let layout = {
            title: "Title",
            yaxis: {title: "Performance score"},
            xaxis: {title: "Date"}
        };

        Plotly.d3.json(url, function(figure) {
            let data = figure.data.reports;
            for (var key in data) {
                xl.push(data[key]["timestamp"]);
                yl.push(data[key]["performance"]);
            }
            let trace = {
                x: xl,
                y: yl
            };

            Plotly.plot(plotlyEl, [trace], layout);
        });
    }
};

drawGraphForMonitor(2);
