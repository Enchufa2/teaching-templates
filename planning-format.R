#!/usr/bin/Rscript

setHook(packageEvent("calendar", "onLoad"), function(...) {
  assignInNamespace("ic_datetime", function (x) {
    if (all(!is.na(x) & !x == "NA" & !grepl("^\\d{8}T\\d{6}Z?$", x)))
      stop("Non-standard time string: should be in this format: 20180809T160000Z")
    plain <- gsub("[TZtz]", "", x)
    datetime <- as.POSIXct(plain, format = "%Y%m%d%H%M%S")
    datetime
  }, "calendar")
})

args <- commandArgs(trailingOnly=TRUE)

if (length(args) == 0 || length(args) > 2) {
  message("Usage: ./planning-format.R <file.ics> <filter_string>")
  quit(status=1)
}

tryCatch({
  ics <- suppressWarnings(calendar::ic_read(args[1]))
}, error=function(e) {
  message("Error: ", args[1], ": ", e$message)
  quit(status=1)
})

if (length(args) == 1) {
  cat(unique(ics$SUMMARY), sep="\n")
  quit()
}

format_time <- function(DTSTART, DTEND) {
  fmt <- "%H"
  if (any(lubridate::minute(DTSTART) != 0 | lubridate::minute(DTEND) != 0))
    fmt <- paste(fmt, "%M", sep=":")
  paste(strftime(DTSTART, fmt), strftime(DTEND, fmt), sep="–")
}

ics <- ics |>
  dplyr::filter(grepl(args[2], SUMMARY)) |>
  dplyr::mutate(Week = lubridate::week(DTSTART)) |>
  dplyr::mutate(Week = Week - Week[1] + 1) |>
  dplyr::mutate(Group = sapply(strsplit(SUMMARY, " "), tail, 1)) |>
  dplyr::mutate(Day = lubridate::wday(DTSTART, TRUE)) |>
  dplyr::mutate(Date = as.Date(DTSTART)) |>
  dplyr::mutate(Time = format_time(DTSTART, DTEND)) |>
  dplyr::mutate(Location = LOCATION) |>
  dplyr::mutate(Contents = "") |>
  dplyr::select(Week:Contents)

head(ics)
file <- paste0("planning-", lubridate::year(ics$Date[1]), ".xlsx")
writexl::write_xlsx(ics, file)
message("\n", file, " written")
