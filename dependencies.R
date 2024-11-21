deps <- Filter(\(x) !requireNamespace(x, quietly=TRUE), c(
  "binb",                         # template for slides
  "tufte",                        # template for exams and exercises
  "calendar", "dplyr", "writexl", # planning format
  NULL
))

install.packages(deps, repos="https://cloud.r-project.org")
# tinytex::install_tinytex()
# tinytex::tlmgr_install("fira")
