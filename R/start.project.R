#' Start project
#'
#' Creates initial directories and files with data loading, libraries, .gitignore, symbolik link towards the data. Tob called from the project repository already created
#'
#' @param data.path character indicating path to the project data
#' @param logger.name character indicating the wanted name for the logger in the Logger Factory
#' @param template.dir character indicating the directory name where the template files are located
#'
#' @export
start.project <- function(data.path,
                          logger.name,
                          template.dir = "project_template/")
{
    dir.create("lib")
    .libPaths("lib")
    jsroot::dependencies(libpath = "lib", jspackages = list("utils" = c("jconfig", "jlogger")))
    logger <- JLoggerFactory("Start Project")
    
    if("./code" %in% list.dirs())
    {
        jlog.warn(logger, "Directory", "code" %c% BC, "already exists. Project creation aborted")
        return(FALSE)
    }
    
    jlog.info(logger, "Creating project directories and files")
    template.path <- system.file(template.dir, package = "jsroot")
    for(fname in list.files(template.path))
    {
        jlog.debug(logger, "Copying file", fname %c% BC)
        file.copy(from = paste(template.path, fname, sep = "/"), to = ".", recursive = TRUE)
    }
    
    logger.fun.name <- gsub(" ", ".", tolower(logger.name))
    
    customize.file(path = "code/start.R",
                   gs.src = c("logger.fun.name", "logger.name"),
                   gs.dest = c(logger.fun.name, logger.name))


    customize.file(path = "code/load.data.R",
                   gs.src = "logger.fun.name",
                   gs.dest = logger.fun.name)   

    jlog.debug(logger, "Creating", ".gitignore" %c% BC)
    git.ignore.lines <- c("lib/",
                          "*~",
                          "*#*",
                          "*.#*",
                          "credentials/",
                          "*.tex",
                          "!header.tex",
                          "*.aux",
                          "*.toc",
                          ".RData",
                          ".DS_Store",
                          "*.rds",
                          "report_data/",
                          "logs/",
                          ".Rhistory",
                          "*.png")
    cat(paste(git.ignore.lines, sep = "\n"), file = ".gitignore", sep = "\n")
    
    jlog.debug(logger, "Creating empty directories", "data dashboard report_data" %c% BC)
    dir.create("data")
    dir.create("dashboard")
    dir.create("report_data")

    jlog.info(logger, "Creating symbolik link to data localized at", data.path %c% BY, "and relative symbolik links for", "dashboard/"%c% C, "and", "report/" %c% C)
    file.symlink(from = data.path, to = "data/")
    file.symlink(from = "../data/", to = "dashboard/")
    file.symlink(from = "../data/", to = "report/")
    file.symlink(from = "../lib/", to = "dashboard/")
    file.symlink(from = "../lib/", to = "report/")
    file.symlink(from = "../code/", to = "dashboard/")
    file.symlink(from = "../code/", to = "report/")
    file.symlink(from = "../report_data/", to = "report/")
}

customize.file <- function(path,
                           gs.src,
                           gs.dest,
                           ...,
                           logger = JLoggerFactory("Start Project"))
{
    nsub <- length(gs.src)
    dest <- readLines(path)
    for(i in 1:nsub)
    {
        jlog.debug(logger, "Turning", gs.src[i] %c% C, "to", gs.dest[i] %c% BC, "in file", path %c% Y)
        dest <- gsub(gs.src[i], gs.dest[i], dest)
    }
    cat(dest, file = path, sep = "\n")
}
