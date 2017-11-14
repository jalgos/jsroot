context("dependencies")

test_that("dependencies work",
{
    jsroot::dependencies(jspackages = list("utils" = c("jlogger",
                                                       "jconfig",
                                                       "jsutils",
                                                       "jsmath",
                                                       "jsstats",
                                                       "jsviz",
                                                       "hugesparse"),
                                           "jalgos-dev"= c("TRF")),
                         cran.packages = c("track",
                                           "data.table",
                                           "ggplot2",
                                           "bit"),
                         github.packages = list("wrathematics" = c("getip"),
                                                "RBigData" = c("remoter", "pbdCS")),
                         libpath = 'jsroot_lib_test')

})

