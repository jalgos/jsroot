context("dependencies")

test_that("cran.packages dependencies work",
{
    expect_output(jsroot::dependencies(cran.packages = c("track", "uuid"),
                                       libpath = 'jsroot_lib_test',
                                       force.cran = TRUE),
                  regexp = "downloaded")
})

test_that("cran.packages dependencies throw an error",
{
    expect_warning(jsroot::dependencies(cran.packages = c("unknown_package"),
                                        libpath = 'jsroot_lib_test',
                                        force.cran = TRUE,
                                        quiet = TRUE))
})


test_that("jspackages dependencies work",
{
    jsroot::dependencies(jspackages = list("utils" = c("jlogger")),
                         libpath = 'jsroot_lib_test',
                         force.jalgos = TRUE,
                         quiet = FALSE)

    expect_equal(
        packageDescription("jlogger")$Package,
        "jlogger"
    )
})

# test_that("github.packages dependencies work",
# {
#     # jsroot::dependencies(github.packages = list("wrathematics" = c("getip"),
#     #                                             "RBigData" = c("remoter", "pbdCS")),
#     #                      libpath = 'jsroot_lib_test')
# })