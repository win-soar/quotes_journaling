import { Application } from "@hotwired/stimulus"
import AutocompleteController from "./autocomplete_controller"

window.Stimulus = Application.start()
Stimulus.register("autocomplete", AutocompleteController)
