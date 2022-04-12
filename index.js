/* jshint node: true, esversion: 6 */
import {Elm} from './src/Main.elm';

var app = Elm.Main.init();

app.ports.sendData_toBrowser.subscribe(function({key, value}) {
    localStorage.setItem(key, value);
    console.log("Item stored");
});

app.ports.requestData_fromBrowser.subscribe(function(key) {
    console.log("Browser received a request from Elm");
    const value = localStorage.getItem(key);
    app.ports.sendData_toElm.send(value);
});
