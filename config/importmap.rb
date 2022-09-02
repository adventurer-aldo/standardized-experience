# Pin npm packages by running ./bin/importmap

pin 'application', preload: true
pin 'react', to: 'https://ga.jspm.io/npm:react@18.2.0/index.js'
pin 'react-dom', to: 'https://ga.jspm.io/npm:react-dom@18.2.0/index.js'
pin 'process', to: 'https://ga.jspm.io/npm:@jspm/core@2.0.0-beta.26/nodelibs/browser/process-production.js'
pin 'scheduler', to: 'https://ga.jspm.io/npm:scheduler@0.23.0/index.js'
pin '@hotwired/turbo-rails', to: 'https://ga.jspm.io/npm:@hotwired/turbo-rails@7.1.3/app/javascript/turbo/index.js'
pin '@hotwired/turbo', to: 'https://ga.jspm.io/npm:@hotwired/turbo@7.1.0/dist/turbo.es2017-esm.js'
pin '@rails/actioncable/src', to: 'https://ga.jspm.io/npm:@rails/actioncable@7.0.3/src/index.js'

pin_all_from 'app/javascript/controllers', under: 'controllers'
pin_all_from 'app/javascript/components', under: 'components'
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
