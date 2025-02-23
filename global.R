repos <- c("https://predictiveecology.r-universe.dev", getOption("repos"))
source("https://raw.githubusercontent.com/PredictiveEcology/pemisc/development/R/getOrUpdatePkg.R")
getOrUpdatePkg("Require", minVer = "0.3.1.9098")
getOrUpdatePkg("pkgload")
getOrUpdatePkg("SpaDES.project", minVer = c( "0.1.1.9015"))
# pkgload::load_all("~/GitHub/Require");pkgload::load_all("~/GitHub/clusters");
# pkgload::load_all("~/GitHub/SpaDES.project")
out <- SpaDES.project::setupProject(
  paths = list(projectPath = "~/GitHub/MPB",
               cachePath = "cache"),
  modules =
    paste0("achubaty/",
           c("LandR_MPB_studyArea@development"
             ,"mpbClimateData@master"
             ,"mpbMassAttacksData@master"
             ,"mpbPine@master"
             ,"mpbRedTopSpread@master")),
  packages = c("reproducible (>= 2.1.1)", "terra", "PredictiveEcology/SpaDES.tools@pointDistance2", "amc (HEAD)",
               "LandR (HEAD)", "usethis", "PredictiveEcology/clusters@main",
               "PredictiveEcology/reproducible@AI",
               "PredictiveEcology/SpaDES.core@box",
               "BioSIM", "googledrive" ),
  options = options(reproducible.useMemoise = TRUE,
                    reproducible.memoisePersist = TRUE,
                    # reproducible.showSimilar = 6,
                    # gargle_oauth_email = "eliotmcintire@gmail.com",
                    gargle_oauth_cache = "~/.secret",
                    useRequire = FALSE,
                    reproducible.inputPaths = "~/data", # This is for prepInputs hardlinks
                    reproducible.objSize = FALSE,
                    reproducible.showSimilar = TRUE,
                    reproducible.cacheSaveFormat = "rds",
                    spades.moduleCodeChecks = FALSE,
                    repos = unique(repos)),
  times = list(start = 2000, end = 2030),
  params = list(.globals = list(.useCache = c(".inputObjects", "init"),
                                lowMemory = TRUE, .plots = c("png"), .runName = "2"),
                mpbClimateData = list(usePrerun = FALSE),
                mpbRedTopSpread = list(type = "DEoptim")),
  Restart = TRUE
  # , useGit = "eliotmcintire"
)

restartOrSimInitAndSpades <- function(out, file = "simPreDispersalFit.qs") {
  # there are tempdir paths
  pathsOrig <- out$paths
  out$paths <- sapply(out$paths, grep, invert = TRUE, value = TRUE, pattern = tempdir(), simplify = TRUE)
  fn <- function(out) out
  cached <- attr(reproducible::Cache(fn(out), .functionName = "restartOrSimInitAndSpades"), ".Cache")$newCache %in% FALSE
  out$paths <- pathsOrig
  if (!cached) {
    message("out has changed; rerunning simInitAndSpades")
    sim <- do.call(SpaDES.core::simInitAndSpades, out)
  } else {
    message("out has not changed; trying restartSpades")
    if (isTRUE(is.null(SpaDES.core:::savedSimEnv()$.sim))) {
      sim <- SpaDES.core::restartSpades(file)
    } else  {
      sim <- SpaDES.core::restartSpades()
    }
  }
}


if (FALSE) {
  devtools::install("~/GitHub/reproducible", upgrade = FALSE)
  devtools::install("~/GitHub/SpaDES.core", upgrade = FALSE)
  devtools::install("~/GitHub/SpaDES.tools", upgrade = FALSE)
  # pkgload::load_all("~/GitHub/Require");
  devtools::install("~/GitHub/clusters", upgrade = FALSE);
  reinstall <- FALSE
}

# pkgload::load_all("~/GitHub/reproducible");
pkgload::load_all("~/GitHub/clusters");
# pkgload::load_all("~/GitHub/SpaDES.core");
# pkgload::load_all("~/GitHub/SpaDES.tools");
# pkgload::load_all("~/GitHub/LandR")
fn <- "simPreDispersalFit.qs"
restartOrSimInitAndSpades(out, fn)
saveState(file = fn)
