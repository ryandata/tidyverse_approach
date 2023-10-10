## R for reproducible scientific documents: knitr, rmarkdown, and beyond
## Ryan Womack, rwomack@rutgers.edu
## 2023-10-10 version

###  What is reproducibility?

####  Credibility in Science 

[Duke “starter set”](http://bioinformatics.mdanderson.org/Supplements/ReproRsch-All/Modified/StarterSet/index.html) and [article](http://science.sciencemag.org/content/353/6303/977?rss=1)

**Replication**, or redoing the (physical) experiment from scratch, is expensive, and may not be possible due to the passage of time. 

**Reproducibility** typically focuses on the computational aspects of data+code = results

[*Science* on Replication and Reproducibility](https://www.science.org/toc/science/334/6060)

### Data Management

Good data management is essential for reproducibility
- Keep raw data pristine and separate from any working data
- Document your variables and data collection as well as anything you yourself would forget when revisiting the project 3 years later in response to a query, as a codebook, data dictionary, or readme.
- Don't work in Excel [if you can] or other manual editing environment for manipulating data
- can create a standardized project directory structure with [ProjectTemplate](http://projecttemplate.net/) package

See [Science Data Management guide](https://libguides.rutgers.edu/grad_sciencedata) for more details.

### Literate Programming

Literate programming is "well-commented" code that explains itself.  Certain environments make this easier. Mathematica notebooks, Jupyter notebooks for Python are examples.

In R, literate programming can be achieved with LaTeX + [Sweave](https://stat.ethz.ch/R-manual/R-devel/library/utils/doc/Sweave.pdf) or *knitr* + *markdown/Rmarkdown* in RStudio.

- can embed R code and run it as the document is generated.
- Code that is “tangled” in with text can be extracted, and formatted documents can be “woven” or "knitted" from the literate program.
- always ensures that the latest data and results are actually incorporated.
- helps to document and explain code in context (literate programming).
- PDF, document, and HTML formats are easy to obtain.
- *formatR* package can clean up your code formatting

### knitr and markdown/RMarkdown

- Markdown + [knitr](https://www.r-project.org/nosvn/pandoc/knitr.html) has become a popular, lightweight replacement for LaTex + Sweave
- RMarkdown (.Rmd) allows R code execution, math formatting in addition to regular Markdown (.md) functionality
- Simple syntax and implementation
- Integrated into RStudio (as well as github for plain markdown)
- Publish documents with one click at [RPubs](http://rpubs.com/ryandata/217248)
- Can fall back on LaTeX/Sweave for more complex document formatting

### Package management

- Open source is an important enabler of reproducibility
- Anyone can grab copies of the software to execute
- And can get older versions if necessary for compatibility
- You can also record information about your computing environment (sessionInfo() in R)
- The **checkpoint** and **packrat** packages automate this process in R
- [miniCRAN](https://cran.r-project.org/web/packages/miniCRAN/index.html). See ["Create a local R package repository using miniCRAN"](https://learn.microsoft.com/en-us/sql/machine-learning/package-management/create-a-local-package-repository-using-minicran?view=sql-server-ver16)
- see also <https://rviews.rstudio.com/2018/01/18/package-management-for-reproducible-r-code/>
- Reprozip, Docker, and Apptainer (formerly Singularity) are more comprehensive solutions, not R specific, to containerized environments

### Creating packages for collaboration

- Data and code can be distributed through packages, start with the package.skeleton() command or use RStudio guidance
- Packages can encapsulate data, analytical functions, and documentation
- see also [Creating a basic template package in R](http://ismayc.github.io/ecots2k16/template_pkg/)
- and [*R Packages*](http://r-pkgs.had.co.nz/) by Hadley Wickham
- notably the [**ropensci**](https://ropensci.org/) project has many packages for reproducibility and collaboration.

### Code sharing and version control

- The same forces (cloud computing, shared platforms, standards) are making collaboration easier than ever
- Github, Bitbucket, and others enable easy collaboration on programming, combined with version control
- with significant side benefits for reproducibility due to availability of code
- The [Open Science Framework](https://osf.io) provides a more data-specific approach
- Many other data repositories exist.  See <https://re3data.org>.
- Rproject in RStudio can integrate with github, packrat, and other tools, but is specific to RStudio

### Conclusion and extensions

For more info see the [CRAN Task View for Reproducible Research](https://cran.r-project.org/web/views/ReproducibleResearch.html)


See [blogdown](https://bookdown.org/yihui/blogdown/) and 

[bookdown](https://bookdown.org/home/)

if you are interested in creating more long-form documents that can incorporate R code and analysis.
