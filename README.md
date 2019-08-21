
<img src="inst/images/logo.PNG" width="400">

The `bootcamp` R package contains materials written to train new
biostatisticians at Cancer Research UK Clinical Trials Unit at the
University of Birmingham. Sessions are presented as
[learnr](https://rstudio.github.io/learnr/) tutorials.

Content includes:

  - Folder structure for trial analysis directories;
  - Using [R](https://www.r-project.org/) &
    [RStudio](https://www.rstudio.com/)
  - Using [git](https://git-scm.com/)
  - Using [ggplot2](https://r4ds.had.co.nz/data-visualisation.html)
  - Using [markdown](https://en.wikipedia.org/wiki/Markdown) and
    [pandoc](https://pandoc.org/)
  - Using [Rmarkdown](https://rmarkdown.rstudio.com/)
  - Core skills in [Stata](https://www.stata.com/)
  - and loads more

If you use any of these materials or want to do something similar at
your institution, please drop a line to <kristian.brock@gmail.com>.

## Installation

You can install `bootcamp` straight from GitHub with `devtools`. If you
do not have devtools, install it with:

``` rinstall_devtools
install.packages('devtools')
```

This package also relies on `dplyr`, `ggplot2` and `learnr`. If you
lack, install them with:

``` r
install.packages('dplyr')
install.packages('ggplot2')
install.packages('learnr')
```

Finally install `bootcamp` using:

``` r
devtools::install_github('brockk/bootcamp')
```

## Running tutorials

To run an interactive tutorial, run:

``` r
learnr::run_tutorial('intro', package = 'bootcamp')
```

When you are done, kill the browser window. If you are running from
RStudio, click the red Stop button in the Console pane.

Tutorials currently available (i.e. valid substitutions for `intro`
above) are:

  - `intro`
  - `folders`
  - `git`
  - `ggplot2`
  - `markdown`

More are coming.

## Running tutorials online

The tutorials are installed on a public RStudio Cloud instance at:

<https://rstudio.cloud/project/454702>

You are free to run them there. Look for the `Run.R` file.

Happy learning. Kristian.

<img src="inst/images/crctu.jpg" width="200">
