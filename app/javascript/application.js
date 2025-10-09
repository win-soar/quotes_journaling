// Entry point for the build script in your package.json

import $ from "jquery";
window.$ = $;
window.jQuery = $;

import "./controllers"
import "bootstrap";
import "@hotwired/turbo-rails";
import "./active_admin"