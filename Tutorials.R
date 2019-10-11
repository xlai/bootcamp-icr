
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

# Welcome to bootcamp
learnr::run_tutorial('bootcamp', package = 'bootcamp')

# Folder structure for trial analyses 
learnr::run_tutorial('folders', package = 'bootcamp')

# Introduction to R & RStudio
learnr::run_tutorial('intro', package = 'bootcamp')

# Introduction to git
learnr::run_tutorial('git', package = 'bootcamp')

# Introduction to ggplot2
learnr::run_tutorial('ggplot2', package = 'bootcamp')

# Introduction to markdown
learnr::run_tutorial('markdown', package = 'bootcamp')

# Introduction to R markdown
learnr::run_tutorial('rmarkdown', package = 'bootcamp')

# Working with database snapshots in R
learnr::run_tutorial('snapshots', package = 'bootcamp')
