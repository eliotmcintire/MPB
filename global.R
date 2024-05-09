source("https://raw.githubusercontent.com/PredictiveEcology/pemisc/development/R/getOrUpdatePkg.R")

getOrUpdatePkg("remotes")
remotes::install_github("PredictiveEcology/Require@simplify4", upgrade = TRUE, ask = FALSE)
# remotes::install_github("PredictiveEcology/SpaDES.project@transition", upgrade = TRUE, ask = FALSE)


out <- SpaDES.project::setupProject(
  paths = list(projectPath = "~/GitHub/MPB"),
  modules =
    paste0("achubaty/",
           c("LandR_MPB_studyArea@development"
             ,"mpbClimateData@HEAD"
             ,"mpbMassAttacksData@HEAD"
             ,"mpbPine@HEAD"
             ,"mpbRedTopSpread@HEAD")),
  packages = c("PredictiveEcology/reproducible@modsForLargeArchives (HEAD)",
               "RNCan/BioSimClient_R", "googledrive"),
  options = options(reproducible.useMemoise = TRUE, reproducible.showSimilar = 6,
                    gargle_oauth_email = "eliotmcintire@gmail.com"),
  times = list(start = 2000, end = 2030),
  params = list(.globals = list(.useCache = c(".inputObjects", "init"), .plots = NA),
                mpbClimateData = list(usePrerun = FALSE)),
  Restart = TRUE, useGit = TRUE)

do.call(SpaDES.core::simInitAndSpades, out)
