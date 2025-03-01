repos <- c("https://predictiveecology.r-universe.dev", getOption("repos"))
source("https://raw.githubusercontent.com/PredictiveEcology/pemisc/development/R/getOrUpdatePkg.R")
getOrUpdatePkg("Require", minVer = "0.3.1.9098")
# getOrUpdatePkg("pkgload")
getOrUpdatePkg("SpaDES.project", minVer = c( "0.1.1.9015"))
# pkgload::load_all("~/GitHub/Require");pkgload::load_all("~/GitHub/clusters");
# pkgload::load_all("~/GitHub/SpaDES.project")
# debug(setupPackages)
out <- SpaDES.project::setupProject(
  coreForFit = c("localhost",
             paste0("n", c(18, 161, 174, 179, 202, 207, 181, 202, 207))),
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
               "LandR (HEAD)", "usethis", "PredictiveEcology/clusters@main (HEAD)",
               "PredictiveEcology/reproducible@AI (HEAD)",
               "PredictiveEcology/SpaDES.core@box (HEAD)",
               "BioSIM", "googledrive" ),
  options = options(reproducible.useMemoise = TRUE,
                    reproducible.memoisePersist = TRUE,
                    # reproducible.showSimilar = 6,
                    gargle_oauth_email = "eliotmcintire@gmail.com",
                    gargle_oauth_cache = "~/.secret",
                    # gargle_oauth_client = "web",
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
                                lowMemory = TRUE, .plots = c("png"), .runName = "MPB_5"),
                mpbClimateData = list(usePrerun = FALSE),
                mpbRedTopSpread = list(type = "DEoptim",
                                       # .runName = "MPB",
                                       coresListForFitting = # NA
                                         {df <- data.table::data.table(
                                           core = coreForFit,
                                           # paste0("n", c(14, 54, 105))),
                                           ncores = c(80, rep(48, length.out = length(coreForFit) - 1))# , rep(16, 3))
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
# pkgload::load_all("~/GitHub/clusters");
# pkgload::load_all("~/GitHub/SpaDES.core");
# pkgload::load_all("~/GitHub/SpaDES.tools");
# pkgload::load_all("~/GitHub/LandR")
fn <- "simPreDispersalFit.qs"
# sim <- SpaDES.core::loadSimList(fn)
sim <- SpaDES.core::restartOrSimInitAndSpades(out, fn)
# sim <- restartOrSimInitAndSpades(out, fn) |> Cache()
saveState(file = fn)


# maps <- lapply(mget(grep("studyArea", ls(sim), value = TRUE), envir = envir(sim)), terra::vect)
# maps <- append(maps, list(propPine = sim$propPineRas))
# area1 <- prepInputs(url = "https://drive.google.com/file/d/1rMTn8TvVq4qjmSwi-Cei0CCc7_p0gg07/view?usp=drive_link")
# maps <- append(list(area1), maps)
# names(maps)[1] <- "rasterToMatch_area1"
# plotSAsLeaflet(sim)

# MPB_3 -- change p_advectionMap to -5 to 5 -- only 7 machines (2 on localhost)
# MPB_4 -- change p_advectionMap to -25 to 5 -- only 7 machines (2 on localhost)
# MPB_5 -- fixed the metadata p_advectionMap to 0 to 500 -- 9 machines

# clusters::rmIncompleteDups(out$paths$outputPath)
