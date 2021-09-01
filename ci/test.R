options(repos = structure(c(CRAN = "https://cloud.r-project.org")))

df <- as.data.frame(devtools::test())

if (any(df[["failed"]] > 0) || any(df[["error"]] == TRUE)) stop("Some tests failed.")
