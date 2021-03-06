source("code/init.R")
logger <- logger.fun.name.logger()

if(!"NAME.TABLE" %in% ls())
{
    jlog.info(logger, "Loading table", "NAME.TABLE" %c% BC)
    NAME.TABLE <- as.data.table(read.csv("path/to/data.csv"))

    set.convention.names(NAME.TABLE)
} else jlog.warn(logger, "NAME.TABLE" %c% BC, "already loaded")
