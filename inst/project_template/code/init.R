.libPaths("lib")

if(!"base.sub.list" %in% ls()) base.sub.list <- list("$util" = "util",
                                                     "$code" = "code",
                                                     "$data" = "data")

jsroot::dependencies(jspackages = list("utils" = c('jconfig',
                                                   'jlogger',
                                                   'jsutils',
                                                   'jsexploration',
                                                   'jsts',
                                                   'datatablebuffer',
                                                   'jsmath',
                                                   'jsstats',
                                                   'jsviz',
                                                   'jsparallel',
                                                   'ddata.table'),
                                       "jalgos-dev" = "TRF"),
                     cran.packages = c('shinydashboard',
                                       'Matrix',
                                       'ggplot2',
                                       'corrplot',
                                       'dbscan',
                                       'rARPACK',
                                       'plotly',
                                       'pbdMPI',
                                       'stringr'),
                     quiet = TRUE)

logger.fun.name.logger <- function() JLoggerFactory("logger.name")
