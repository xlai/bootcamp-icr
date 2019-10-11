

library(rmarkdown)
getwd()
render(input = 'inst/tutorials/intro/intro.Rmd', 
       output_format = 'html_document', 
       output_file = 'MyTest')
