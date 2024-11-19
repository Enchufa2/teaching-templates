render_with_solution <- function(input, ...) {
  output_sol <- paste(xfun::sans_ext(input), "sol", sep="-")
  rmarkdown::render(input, output_file=output_sol, params=list(solution=TRUE))
  rmarkdown::render(input, params=list(solution=FALSE))
}

setup_solution <- function(params=parent.frame()$params, pagebreaks=FALSE) {
  with_solution <- paste0(
    "\\specialcomment{solution}{\\noindent\\textbf{Solution:} }{",
    if (pagebreaks) "\\pagebreak", "}")
  without_solution <- "\\excludecomment{solution}"
  if (isTRUE(params$solution))
    cat(with_solution) else cat(without_solution)
}

option <- function(correct=FALSE, params=parent.frame()$params) {
  if (correct && isTRUE(params$solution))
    "\\item[\\large$\\boxtimes$]" else "\\item[\\large$\\square$]"
}

cat <- function(...) base::cat(..., sep="", fill=TRUE)

get_questionnaire <- function(file) {
  x <- readLines(file)
  x <- x[!grepl("^#", x)]
  lapply(split(x, cumsum(x == "")), function(x) {
    x <- x[x != ""]
    q <- x[1]
    a <- x[-1]
    correct <- grep("^\\+", a)
    a <- substring(a, 3)
    list(question=q, answers=a, correct=correct)
  })
}

cat_question <- function(x, i, ncol, params=parent.frame()$params) {
  width <- max(sapply(x$answers, nchar))
  if (missing(ncol))
    ncol <- ifelse(width < 22, 4, ifelse(width < 50, 2, 1))
  cat("\\begin{minipage}{\\linewidth}")
  cat("\\newthought{Q", i, "}. ", x$question)
  cat("\\vspace{-2mm}")
  if (ncol > 1) cat("\\begin{multicols}{", ncol, "}")
  cat("\\begin{itemize}\\setlength\\itemsep{0em}")
  for (j in sample(length(x$answers)))
    cat(option(j == x$correct), x$answers[j])
  cat("\\end{itemize}")
  if (ncol > 1) cat("\\end{multicols}")
  #cat("\\vspace{\\parskip}")
  cat("\\end{minipage}")
}
