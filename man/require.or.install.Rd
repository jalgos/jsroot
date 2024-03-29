% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/install.R
\name{require.or.install}
\alias{require.or.install}
\alias{require.or.install.dev}
\title{Install Missing Package}
\usage{
require.or.install(
  name,
  ...,
  install.fun = install.git,
  load.fun = require,
  require.name = name,
  force = FALSE,
  install.missing = TRUE,
  version = branch,
  branch = NULL,
  libpath = "lib"
)

require.or.install.dev(name, url.pattern = file.package.pattern, ...)
}
\arguments{
\item{name}{Name of the package}

\item{...}{to be forwarded to install.fun}

\item{install.fun}{Package installation function to use}

\item{load.fun}{how should the package be attached 'library' or 'require'}

\item{force}{force install}

\item{install.missing}{should we install missing packages}
}
\description{
Install Missing Package
}
\section{Functions}{
\itemize{
\item \code{require.or.install}: Install specified package in case call to \code{require} fails.

\item \code{require.or.install.dev}: For development use. Installs package directly from directory not from remote repo
}}

