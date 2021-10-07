context("dependencies")

test_that("dependencies work",
{
    if(dir.exists('jsroot_lib_test')) unlink('jsroot_lib_test', recursive = TRUE, force = TRUE)

    jsroot::dependencies(jspackages = list("utils" = list(c("jconfig"),
                                                          c("jlogger", branch = "1.0.7"),
                                                          c("jsutils", version = "1.0.9"))),
                         cran.packages = list("track",
                                              c("data.table", version = "1.13.0")),
                         github.packages = list("wrathematics" = c("getip"),
                                                "RBigData" = c("remoter", "pbdCS")),
                         upgrade = FALSE,
                         libpath = 'jsroot_lib_test')

    expect_true(packageVersion("data.table", lib.loc = 'jsroot_lib_test') == "1.13.0")
    expect_true(packageVersion("jsutils", lib.loc = 'jsroot_lib_test') == "1.0.9")
    expect_true(packageVersion("jlogger", lib.loc = 'jsroot_lib_test') == "1.0.7")
    invisible(sapply(c("getip", "remoter", "pbdCS", "track", "jconfig"),
                     function(pkg) expect_true(require(pkg,
                                                       character = TRUE))))

    jsroot::dependencies(jspackages = list("utils" = list(c("jlogger", branch = "1.0.8"),
                                                          c("jsutils", version = "1.0.10"))),
                         cran.packages = list(c("data.table", version = "1.14.0")),
                         upgrade = FALSE,
                         libpath = 'jsroot_lib_test')

    expect_true(packageVersion("data.table", lib.loc = 'jsroot_lib_test') == "1.14.0")
    expect_true(packageVersion("jsutils", lib.loc = 'jsroot_lib_test') == "1.0.10")
    expect_true(packageVersion("jlogger", lib.loc = 'jsroot_lib_test') == "1.0.8")
})
