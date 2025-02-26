repos <- c("https://predictiveecology.r-universe.dev", getOption("repos"))
source("https://raw.githubusercontent.com/PredictiveEcology/pemisc/development/R/getOrUpdatePkg.R")
getOrUpdatePkg("Require", minVer = "0.3.1.9098")
# getOrUpdatePkg("pkgload")
getOrUpdatePkg("SpaDES.project", minVer = c( "0.1.1.9015"))
# pkgload::load_all("~/GitHub/Require");pkgload::load_all("~/GitHub/clusters");
# pkgload::load_all("~/GitHub/SpaDES.project")
# debug(setupPackages)
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
  packages = c("terra", "PredictiveEcology/SpaDES.tools@pointDistance2", "amc (HEAD)",
               "LandR (HEAD)", "usethis", "PredictiveEcology/clusters@main",
               "PredictiveEcology/reproducible@AI (HEAD)",
               "PredictiveEcology/SpaDES.core@box (HEAD)",
               "BioSIM", "googledrive" ),
  options = options(reproducible.useMemoise = TRUE,
                    reproducible.memoisePersist = TRUE,
                    # reproducible.showSimilar = 6,
                    # gargle_oauth_email = "eliotmcintire@gmail.com",
                    gargle_oauth_cache = "~/.secret",
                    spades.useRequire = FALSE,
                    # SpaDES.project.fast = FALSE,
                    reproducible.inputPaths = "~/data", # This is for prepInputs hardlinks
                    reproducible.objSize = FALSE,
                    reproducible.showSimilar = TRUE,
                    reproducible.cacheSaveFormat = "rds",
                    # reproducible.useCache = TRUE,
                    spades.moduleCodeChecks = FALSE,
                    repos = unique(repos)),
  times = list(start = 2000, end = 2030),
  params = list(.globals = list(.useCache = c(".inputObjects", "init"),
                                lowMemory = TRUE, .plots = c("png"), .runName = "MPB_2"),
                mpbClimateData = list(usePrerun = FALSE),
                mpbRedTopSpread = list(type = "DEoptim",
                                       # .runName = "MPB",
                                       .coresList =
                                       #  lapply(
                                       #   # "n161", rep, 30)
                                       # c("localhost",
                                       #   paste0("n", c(18, 161, 168, 174, 179, 181))), # 42, 171, and the slower 164 are offline
                                       #  rep, each = 30)
                                       # )),
                                         {df <- data.table::data.table(core = c("localhost",
                                                                                paste0("n", c(18, 161, 168, 174, 179, 181, 202, 207))),
                                                                       # paste0("n", c(14, 54, 105))),
                                                                       ncores = c(80, rep(48, 8))# , rep(16, 3))
                                         )
                                         df[, ncoresUse := round(0.75 * ncores)]
                                         df2 <- data.table::data.table(core = rep(df$core, df$ncoresUse))
                                         data.table::setorder(df2, core)
                                         df2[, `:=`(coreID = cumsum(c(0, diff(as.factor(core)))))]
                                         iterID <- rep(seq(ceiling(NROW(df2)/30)), each = 30)
                                         df2[, split := iterID[seq(NROW(df2))]]
                                         df3 <- df2[, .(hasEnough = .N == 30), by = "split"][hasEnough %in% TRUE]
                                         df2 <- df2[df3, on = "split"]
                                         df <- split(df2, by = "split")
                                         lapply(df, function(x) x$core)}
                )),


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
  hasSavedToRAMState <- !is.null(SpaDES.core:::savedSimEnv()$.sim)
  hasSavedToFileState <- file.exists(file)
  if (!cached || !(hasSavedToFileState || hasSavedToRAMState)) {
    message("out has changed; rerunning simInitAndSpades")
    sim <- do.call(SpaDES.core::simInitAndSpades, out)
  } else {
    message("out has not changed; trying restartSpades")
    if (isFALSE(hasSavedToRAMState)) {
      sim <- SpaDES.core::restartSpades(file)
    } else  {
      sim <- SpaDES.core::restartSpades()
    }
  }
}


if (FALSE) {
  devtools::install("~/GitHub/SpaDES.project", upgrade = FALSE)
  devtools::install("~/GitHub/reproducible", upgrade = FALSE)
  devtools::install("~/GitHub/SpaDES.core", upgrade = FALSE)
  devtools::install("~/GitHub/SpaDES.tools", upgrade = FALSE)
  # pkgload::load_all("~/GitHub/Require");
  devtools::install("~/GitHub/clusters", upgrade = FALSE);
  reinstall <- FALSE
}

# pkgload::load_all("~/GitHub/reproducible");
# pkgload::load_all("~/GitHub/SpaDES.project");
pkgload::load_all("~/GitHub/clusters");
# pkgload::load_all("~/GitHub/SpaDES.core");
# pkgload::load_all("~/GitHub/SpaDES.tools");
# pkgload::load_all("~/GitHub/LandR")
fn <- "simPreDispersalFit.qs"
# sim <- SpaDES.core::loadSimList(fn)
restartOrSimInitAndSpades(out, fn)
# saveState(file = fn)


# maps <- lapply(mget(grep("studyArea", ls(sim), value = TRUE), envir = envir(sim)), terra::vect)
# maps <- append(maps, list(propPine = sim$propPineRas))
# area1 <- prepInputs(url = "https://drive.google.com/file/d/1rMTn8TvVq4qjmSwi-Cei0CCc7_p0gg07/view?usp=drive_link")
# maps <- append(list(area1), maps)
# names(maps)[1] <- "rasterToMatch_area1"
# plotSAsLeaflet(sim)
