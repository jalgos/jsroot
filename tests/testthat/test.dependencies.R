context("dependencies")

#' Removes jsroot_lib_test before each test to make sure each test is isolated
clean_before <- function() {
    system("rm -Rf jsroot_lib_test")
}

test_that("jsroot installs cran.packages successfully",
{
    clean_before()

    expect_output(jsroot::dependencies(cran.packages = c("track", "uuid"),
                                       libpath = 'jsroot_lib_test',
                                       force.cran = TRUE),
                  regexp = "downloaded")
})

test_that("jsroot throws an error for unknown cran.packages dependencies",
{
    clean_before()

    expect_warning(jsroot::dependencies(cran.packages = c("unknown_package"),
                                        libpath = 'jsroot_lib_test',
                                        force.cran = TRUE,
                                        quiet = TRUE))
})


test_that("jsroot installs jspackages successfully",
{
    clean_before()

    jsroot::dependencies(cran.packages = c("track", "uuid"), # jslogger track and uuid should be installed, beacase jlogger uses it
                         jspackages = list("utils" = c("jlogger")),
                         libpath = 'jsroot_lib_test',
                         force.cran = TRUE,
                         force.jalgos = TRUE,
                         quiet = FALSE)

    expect_equal(packageDescription("jlogger")$Package,
                "jlogger")
})

test_that("jsroot installs github.packages successfully",
{
    clean_before()

    jsroot::dependencies(github.packages = list("tidyverse" = c("purrr")),
                         libpath = 'jsroot_lib_test',
                         force.github = TRUE)

    expect_equal(packageDescription("purrr")$Package, "purrr")
    expect_true(packageDescription("purrr")$Version != "0.3.0")
})

test_that("jsroot installs github.packages with specific version successfully",
{
    clean_before()

    jsroot::dependencies(github.packages = list("tidyverse" = c("purrr@v0.3.0")),
                         libpath = 'jsroot_lib_test',
                         force.github = TRUE)

    expect_true(packageDescription("purrr")$Version == "0.3.0")
})
