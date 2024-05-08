source("https://raw.githubusercontent.com/PredictiveEcology/pemisc/development/R/getOrUpdatePkg.R")

getOrUpdatePkg("remotes")
remotes::install_github("PredictiveEcology/Require@simplify4", upgrade = TRUE, ask = FALSE)
# remotes::install_github("PredictiveEcology/SpaDES.project@transition", upgrade = TRUE, ask = FALSE)


out <- SpaDES.project::setupProject(
  paths = list(projectPath = "~/GitHub/MPB"),
  modules =
    paste0("achubaty/",
           c("LandR_MPB_studyArea"
             ,"mpbClimateData"
             ,"mpbMassAttacksData"
             ,"mpbPine"
             ,"mpbRedTopSpread"), "@HEAD"),
  packages = c("PredictiveEcology/reproducible@modsForLargeArchives (HEAD)",
               "RNCan/BioSimClient_R", "googledrive"),
  options = list(reproducible.useMemoise = TRUE, reproducible.showSimilar = 6),
  times = list(start = 2010, end = 2030),
  params = list(.globals = list(.useCache = c(".inputObjects"), .plots = NA)),
  Restart = TRUE, useGit = TRUE)

do.call(SpaDES.core::simInitAndSpades, out)
