deps <- c(
  "binb",
  "calendar",
  "dplyr",
  "tufte",
  "writexl"
)

deps <- Filter(function(x) !requireNamespace(x, quietly=TRUE), deps)

install.packages(deps, repos="https://cloud.r-project.org")
# tinytex::install_tinytex()
# tinytex::tlmgr_install("fira")
