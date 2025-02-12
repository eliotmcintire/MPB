repos <- c("https://predictiveecology.r-universe.dev", getOption("repos"))
source("https://raw.githubusercontent.com/PredictiveEcology/pemisc/development/R/getOrUpdatePkg.R")
getOrUpdatePkg("Require", minVer = "0.3.1.9098")
# getOrUpdatePkg("pkgload")
getOrUpdatePkg("SpaDES.project", minVer = c( "0.1.0.9015"))
# options("SpaDES.project.packages" = NULL)
# pkgload::load_all("~/GitHub/SpaDES.project");
out <- SpaDES.project::setupProject(
  paths = list(projectPath = "~/GitHub/MPB"),
  modules =
    paste0("achubaty/",
           c("LandR_MPB_studyArea@development"
             ,"mpbClimateData@master"
             ,"mpbMassAttacksData@master"
             ,"mpbPine@master"
             ,"mpbRedTopSpread@master")),
  packages = c("reproducible (>= 2.1.1)", "terra", "SpaDES.tools (HEAD)", "amc (HEAD)",
               "LandR (HEAD)", "usethis",
               "PredictiveEcology/reproducible@AI (HEAD)",
               "PredictiveEcology/SpaDES.core@box (HEAD)",
               "BioSIM", "googledrive" ),
  options = options(reproducible.useMemoise = TRUE,
                    # reproducible.showSimilar = 6,
                    # gargle_oauth_email = "eliotmcintire@gmail.com",
                    gargle_oauth_cache = "~/.secret",
                    useRequire = FALSE,
                    reproducible.objSize = FALSE,
                    spades.moduleCodeChecks = FALSE,
                    repos = unique(repos)),
  times = list(start = 2000, end = 2030),
  params = list(.globals = list(.useCache = c(".inputObjects", "init"),
                                lowMemory = TRUE, .plots = NA),
                mpbClimateData = list(usePrerun = FALSE)),
  Restart = TRUE
 , useGit = "eliotmcintire"
)
# pkgload::load_all("~/GitHub/Require"); pkgload::load_all("~/GitHub/reproducible")
sim <- do.call(SpaDES.core::simInitAndSpades, out)
