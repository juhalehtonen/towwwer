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

if (document.getElementById('plotly')) {
    let plotlyEl = document.getElementById('plotly');

    let url = 'https://raw.githubusercontent.com/FreeCodeCamp/ProjectReferenceData/master/GDP-data.json';
    let xl = [];
    let yl = [];
    Plotly.d3.json(url, function(figure){
        let data = figure.data;
        for (var i=0; i< data.length; i++) {
            xl.push(data[i][0]);
            yl.push(data[i][1]);
        }
        let trace = {
            x: xl,
            y: yl
        };
        Plotly.plot(plotlyEl, [trace]); });
}
