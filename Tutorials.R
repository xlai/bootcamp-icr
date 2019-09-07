
# You need devtools to install straight from GitHub
# If you do not have it, uncomment below and run:
# install.packages('devtools')

# With devtools installed, you can install KB's bootcamp project from GitHub:
devtools::install_github('brockk/bootcamp')

# You need learnr to run interactive tutorials. If you do not have it, 
# uncomment below and run
# install.packages('learnr')
library(learnr)

# Run the tutorials one at a time.
# Click the red STOP button in the Console pane to end a tutorial.
# You must stop a tutorial before you can run the next!


run_tutorial('folders', package = 'bootcamp')

run_tutorial('intro', package = 'bootcamp')

run_tutorial('git', package = 'bootcamp')

run_tutorial('ggplot2', package = 'bootcamp')

run_tutorial('markdown', package = 'bootcamp')

run_tutorial('rmarkdown', package = 'bootcamp')
