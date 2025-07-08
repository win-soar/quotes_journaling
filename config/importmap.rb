# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

# Bootstrap と Popper
pin "bootstrap", to: "bootstrap.js"
pin "@popperjs/core", to: "popper.js"

# Popper の依存（必要に応じて追加）
pin "@popperjs/core/lib/popper-lite", to: "popper-lite.js"
pin "@popperjs/core/lib/utils/getOppositePlacement", to: "utils/getOppositePlacement.js"
pin "@popperjs/core/lib/utils/detectOverflow", to: "utils/detectOverflow.js"
pin "@popperjs/core/lib/dom-utils/getViewportRect", to: "dom-utils/getViewportRect.js"
pin "@popperjs/core/lib/dom-utils/getHTMLElementScroll", to: "dom-utils/getHTMLElementScroll.js"
pin "@popperjs/core/lib/modifiers/applyStyles", to: "modifiers/applyStyles.js"
pin "@popperjs/core/lib/modifiers/flip", to: "modifiers/flip.js"
pin "@popperjs/core/lib/modifiers/hide", to: "modifiers/hide.js"
pin "@popperjs/core/lib/modifiers/index", to: "modifiers/index.js"

pin "@rails/ujs", to: "@rails--ujs.js"
