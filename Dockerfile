FROM reg.jalgos.ai/r-mpi:4.0.3

WORKDIR /build
COPY ci /build/ci

RUN install2.r \
  --skipinstalled \
  --error \
  --deps TRUE \
  --repos https://cran.rstudio.com \
  RJSONIO

COPY . /build
