## Courtesy of RcppParallel https://github.com/RcppCore/RcppParallel/blob/master/tools/config.R

#' Configure a File
#'
#' Configure a file, replacing (by default) any instances of `@`-delimited
#' variables, e.g. `@VAR@`, with the value of the variable called `VAR` in the
#' associated `config` environment.
#'
#' @param source The file to be configured.
#' @param target The file to be generated.
#' @param config The configuration database.
#' @param lhs The left-hand side marker; defaults to `@`.
#' @param rhs The right-hand side marker; defaults to `@`.
#' @param verbose Boolean; report files as they are configured?
#'
#' @family configure
#'
#' @export
configure_file <- function(source,
                           target = sub("[.]in$",
                                        "",
                                        source),
                           config = Sys.getenv(),
                           lhs = "@",
                           rhs = "@",
                           verbose = TRUE)
{
    contents <- readLines(source, warn = FALSE)

    for(var in names(config))
    {
        needle <- paste(lhs, var, rhs, sep = "")
        replacement <- config[[var]]
        contents <- gsub(needle,
                         replacement,
                         contents,
                         fixed = TRUE)
    }

    writeLines(contents, con = target)

    info <- file.info(source)
    Sys.chmod(target, mode = info$mode)

    if (isTRUE(verbose))
    {
        fmt <- "*** configured file: '%s' => '%s'"
        message(sprintf(fmt, source, target))
    }
}

#' Configures Modular Files
#'
#' Will replace variables appearing in the file with a .in extension
#' @export
configure <- function(...)
{

    sources <- list.files(path = c("R", "src"),
                          pattern = "[.]in$",
                          full.names = TRUE)

    sources <- sub("[.]/", "", sources)

    lapply(sources, configure_file, ...)
    
    invisible(TRUE)
}

#' Checks Jalgos Environment
#'
#' Checks that Jalgos environment variables are set
#' @param lib.var Variable that locate jalgos libs
#' @param include.var Variable that locate jalgos includes
#' @param config Set of variables
#' @export
check.jalgos.compatible <- function(pkg.name,
                                    lib.var = "JALGOS_LIB",
                                    include.var = "JALGOS_INCLUDE",
                                    config = Sys.getenv())
{
    env.vars <- names(config)
    if(!lib.var %in% env.vars)
    {
        cat("Library var:", lib.var, "is not set and needed by package:", pkg.name, " for installation\n")
        warning(sprintf("Jalgos lib var is not set for package %s", pkg.name))
        return(FALSE)
    }

    if(!include.var %in% env.vars)
    {
        cat("Include var:", include.var, "is not set and needed by package:", pkg.name, "for installation\n")
        warning(sprintf("Jalgos include var is not set for package %s", pkg.name))
        return(FALSE)
    }

    jalgos.libs <- config[lib.var]
    if(!grepl(jalgos.libs, Sys.getenv("LD_LIBRARY_PATH")))
    {
        cat(lib.var, sprintf("is not included in search path. You can do it by updating the library path like this: `export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$%s and restart R", lib.var))
        warning(sprintf("Jalgos lib var is not included in LD_LIBRARY_PATH for package %s", pkg.name))
        return(FALSE)
    }

    TRUE
}

#' Pre Installation Script
#'
#' Will check the proper setting of Jalgos environment variables and then run `configure`.
#' @param config.file The configuration file for the configure script. Defaults to the last parameter given to the script
#' @export
check.and.configure <- function(config.file = cargs[length(cargs)],
                                                    ...)
{
    cargs <- commandArgs()
    config.file <- cargs[length(cargs)]
    config <- list()
    if(file.exists(config.file))
    {
        config <- as.list(source(config.file)$value)
    }
    config <- c(config,
                Sys.getenv())
    pkg.name <- gsub("Package: ",
                     "",
                     readLines("DESCRIPTION", 1))
    if(!check.jalgos.compatible(pkg.name = pkg.name,
                                config = config,
                                ...))
    {
        if((!"ignore.src" %in% names(config)) || !as.logical(config[["ignore.src"]]))
        {
            cat("Jalgos variables are not set, package", pkg.name, "can't be installed\n")
            stop(sprintf("Jalgos variables need to be set to install package: %s", pkg.name))
        }

        cat("Package can be installed without the compile code, changing package structure appropriately\n")
        warning(sprintf("Package %s will be installed without compiled code", pkg.name))
        system("rm -R src")
        nmsp <- readLines("NAMESPACE")
        udn <- nmsp == sprintf("useDynLib(%s)",
                               pkg.name)
        nmsp <- nmsp[!udn]
        writeLines(nmsp, "NAMESPACE")
    }

    configure(config = config)
}
