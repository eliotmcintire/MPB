source("https://raw.githubusercontent.com/PredictiveEcology/pemisc/development/R/getOrUpdatePkg.R")
getOrUpdatePkg("Require", minVer = "0.3.1.9081")
getOrUpdatePkg("SpaDES.project", minVer = c( "0.0.8.9050"))
getOrUpdatePkg("pkgload")
#remotes::install_github("PredictiveEcology/Require@simplify4", upgrade = TRUE, ask = FALSE)
# remotes::install_github("PredictiveEcology/SpaDES.project@transition", upgrade = TRUE, ask = FALSE)
# pkgload::load_all("~/GitHub/SpaDES.project")


out <- SpaDES.project::setupProject(
  paths = list(projectPath = "~/GitHub/MPB"),
  modules =
    paste0("achubaty/",
           c("LandR_MPB_studyArea@development"
             ,"mpbClimateData@HEAD"
             ,"mpbMassAttacksData@HEAD"
             ,"mpbPine@HEAD"
             ,"mpbRedTopSpread@HEAD")),
  packages = c("PredictiveEcology/reproducible@development (HEAD)",
               "PredictiveEcology/SpaDES.core@sequentialCaching (HEAD)",
               "RNCan/BioSimClient_R", "googledrive" ),
  options = options(reproducible.useMemoise = TRUE, reproducible.showSimilar = 6,
                    gargle_oauth_email = "eliotmcintire@gmail.com",
                    gargle_oauth_cache = ".secret",
                    spades.moduleCodeChecks = FALSE),
  times = list(start = 2000, end = 2030),
  params = list(.globals = list(.useCache = c(".inputObjects", "init"), .plots = NA),
                mpbClimateData = list(usePrerun = FALSE)),
  Restart = TRUE)#, useGit = "eliotmcintire")
sim <- do.call(SpaDES.core::simInitAndSpades, out)
