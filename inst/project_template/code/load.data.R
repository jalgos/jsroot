source("code/start.R")
logger <- logger.fun.name.logger()

if(!"NAME.TABLE" %in% ls())
{
    jlog.info(logger, "Loading table", "NAME.TABLE" %c% BC)
    NAME.TABLE <- as.data.table(read.csv("path/to/data.csv"))

    set.conv.names(NAME.TABLE)
}
