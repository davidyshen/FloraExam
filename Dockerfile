FROM rocker/verse:4.2.2
RUN apt-get update && apt-get install -y  gdal-bin git-core imagemagick libcurl4-openssl-dev libgdal-dev libgeos-dev libgeos++-dev libgit2-dev libicu-dev libpng-dev libproj-dev libssl-dev libxml2-dev make pandoc zlib1g-dev && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /usr/local/lib/R/etc/ /usr/lib/R/etc/
RUN echo "options(repos = c(CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl', Ncpus = 4)" | tee /usr/local/lib/R/etc/Rprofile.site | tee /usr/lib/R/etc/Rprofile.site
RUN R -e 'install.packages("remotes")'
RUN Rscript -e 'remotes::install_version("rlang",upgrade="never", version = "1.0.6")'
RUN Rscript -e 'remotes::install_version("stringr",upgrade="never", version = "1.5.0")'
RUN Rscript -e 'remotes::install_version("dplyr",upgrade="never", version = "1.1.0")'
RUN Rscript -e 'remotes::install_version("ggplot2",upgrade="never", version = "3.4.1")'
RUN Rscript -e 'remotes::install_version("rmarkdown",upgrade="never", version = "2.20")'
RUN Rscript -e 'remotes::install_version("shiny",upgrade="never", version = "1.7.4")'
RUN Rscript -e 'remotes::install_version("tidyr",upgrade="never", version = "1.3.0")'
RUN Rscript -e 'remotes::install_version("config",upgrade="never", version = "0.3.1")'
RUN Rscript -e 'remotes::install_version("webshot2",upgrade="never", version = "0.1.0")'
RUN Rscript -e 'remotes::install_version("testthat",upgrade="never", version = "3.1.6")'
RUN Rscript -e 'remotes::install_version("spelling",upgrade="never", version = "2.2")'
RUN Rscript -e 'remotes::install_version("kableExtra",upgrade="never", version = "1.3.4")'
RUN Rscript -e 'remotes::install_version("bookdown",upgrade="never", version = "0.30")'
RUN Rscript -e 'remotes::install_version("shinyWidgets",upgrade="never", version = "0.7.6")'
RUN Rscript -e 'remotes::install_version("plotly",upgrade="never", version = "4.10.1")'
RUN Rscript -e 'remotes::install_version("leaflet",upgrade="never", version = "2.1.1")'
RUN Rscript -e 'remotes::install_version("golem",upgrade="never", version = "0.3.5")'
RUN Rscript -e 'remotes::install_version("ggrepel",upgrade="never", version = "0.9.3")'
RUN Rscript -e 'remotes::install_version("pagedown",upgrade="never", version = "0.2.0")'
RUN Rscript -e 'remotes::install_github("hadley/lazyeval@f2ee93f5560df506a5ce3bdac7315e82c464408b")'
RUN Rscript -e 'remotes::install_github("rstudio/crosstalk@8128ef3be2a5c79e3818e5df20da4c2bb4b69503")'
RUN Rscript -e 'remotes::install_github("ramnathv/htmlwidgets@843eee94168d9ab1afffae6623d80857a8502ee1")'
RUN Rscript -e 'remotes::install_github("Sustainscapes/Artscore@64eaf5a9d32ec62fff1cce1523ca0fa3e669416a")'
RUN mkdir /build_zone
ADD . /build_zone
WORKDIR /build_zone
RUN R -e 'remotes::install_github("Sustainscapes/FloraExam")'
RUN rm -rf /build_zone
EXPOSE 80
CMD R -e "options('shiny.port'=80,shiny.host='0.0.0.0');FloraExam::run_app()"
