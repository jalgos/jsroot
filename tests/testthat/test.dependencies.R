context("dependencies")

#' Removes jsroot_lib_test before each test to make sure each test is isolated
clean_before <- function() {
    system("rm -Rf jsroot_lib_test")
    system("ls -la")
}

test_that("cran.packages dependencies work",
{
    clean_before()

    expect_output(jsroot::dependencies(cran.packages = c("track", "uuid"),
                                       libpath = 'jsroot_lib_test',
                                       force.cran = TRUE),
                  regexp = "downloaded")
})

test_that("cran.packages dependencies throw an error",
{
    clean_before()

    expect_warning(jsroot::dependencies(cran.packages = c("unknown_package"),
                                        libpath = 'jsroot_lib_test',
                                        force.cran = TRUE,
                                        quiet = TRUE))
})


test_that("jspackages dependencies work",
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

test_that("github.packages dependencies work",
{
    clean_before()

    jsroot::dependencies(github.packages = list("tidyverse" = c("purrr")),
                         libpath = 'jsroot_lib_test')

    expect_equal(packageDescription("purrr")$Package, "purrr")
})