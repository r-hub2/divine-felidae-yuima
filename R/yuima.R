ybook <- function(chapter) {
  chapter <- as.integer(chapter[1])
  if (chapter %in% 1:7) {
    file.show(file.path(.libPaths()[1], "yuima", "ybook", sprintf("chapter%d.R", chapter)))
  } else {
    cat("\nPlease choose an integer number within 1 and 7")
  }
}

yuima.stop <- function(x) {
  stop(sprintf("\nYUIMA: %s\n", x))
}

yuima.warn <- function(x) {
  warning(sprintf("\nYUIMA: %s\n", x))
}

# 22/11/2013
# We introduce a new utility yuima.simplify that allows us to simplify
# the expressions in the drift, diffusion and jump terms.

# yuima.Simplify modified from the original code  Simplify.R
# by Andrew Clausen <clausen@econ.upenn.edu> in 2007.
# http://economics.sas.upenn.edu/~clausen/computing/Simplify.R

# This isn't a serious attempt at simplification code.  It just does some
# obvious things like 0 + x => x.  It was written to support Deriv.R.

yuima.Simplify <- function(expr, yuima.env) {

  ###


  Simplify_ <- function(expr) {
    if (is.symbol(expr)) {
      expr
    } else if (is.language(expr) && is.symbol(expr[[1]])) {
      # is there a rule in the table?
      sym.name <- as.character(expr[[1]])
      #            if (class(try(Simplify.rule <-
      #            get(sym.name, envir=yuima.env,
      #            inherits=FALSE), silent=TRUE))
      #            != "try-error")
      tmpOutTry <- try(Simplify.rule <-
        get(sym.name,
          envir = yuima.env,
          inherits = FALSE
        ), silent = TRUE)

      if (!inherits(tmpOutTry, "try-error")) {
        return(Simplify.rule(expr))
      }
    }
    expr
  }

  Simplify.function <- function(f, x = names(formals(f)), env = parent.frame()) {
    stopifnot(is.function(f))
    as.function(c(
      as.list(formals(f)),
      Simplify_(body(f))
    ),
    envir = env
    )
  }

  `Simplify.+` <- function(expr) {
    if (length(expr) == 2) {
      if (is.numeric(expr[[2]])) {
        return(+expr[[2]])
      }
      return(expr)
    }

    a <- Simplify_(expr[[2]])
    b <- Simplify_(expr[[3]])

    if (is.numeric(a) && all(a == 0)) {
      b
    } else if (is.numeric(b) && all(b == 0)) {
      a
    } else if (is.numeric(a) && is.numeric(b)) {
      a + b
    } else {
      expr[[2]] <- a
      expr[[3]] <- b
      expr
    }
  }

  `Simplify.-` <- function(expr) {
    if (length(expr) == 2) {
      if (is.numeric(expr[[2]])) {
        return(-expr[[2]])
      }
      return(expr)
    }

    a <- Simplify_(expr[[2]])
    b <- Simplify_(expr[[3]])

    if (is.numeric(a) && all(a == 0)) {
      -b
    } else if (is.numeric(b) && all(b == 0)) {
      a
    } else if (is.numeric(a) && is.numeric(b)) {
      a - b
    } else {
      expr[[2]] <- a
      expr[[3]] <- b
      expr
    }
  }

  `Simplify.(` <- function(expr) {
    expr[[2]]
  }

  `Simplify.*` <- function(expr) {
    a <- Simplify_(expr[[2]])
    b <- Simplify_(expr[[3]])

    if (is.numeric(a) && all(a == 0)) {
      0
    } else if (is.numeric(b) && all(b == 0)) {
      0
    } else if (is.numeric(a) && all(a == 1)) {
      b
    } else if (is.numeric(b) && all(b == 1)) {
      a
    } else if (is.numeric(a) && is.numeric(b)) {
      a * b
    } else {
      expr[[2]] <- a
      expr[[3]] <- b
      expr
    }
  }

  `Simplify.^` <- function(expr) {
    a <- Simplify_(expr[[2]])
    b <- Simplify_(expr[[3]])

    if (is.numeric(a) && all(a == 0)) {
      0
    } else if (is.numeric(b) && all(b == 0)) {
      1
    } else if (is.numeric(a) && all(a == 1)) {
      1
    } else if (is.numeric(b) && all(b == 1)) {
      a
    } else if (is.numeric(a) && is.numeric(b)) {
      a^b
    } else {
      expr[[2]] <- a
      expr[[3]] <- b
      expr
    }
  }

  `Simplify.c` <- function(expr) {
    args <- expr[-1]
    args.simplified <- lapply(args, Simplify_)
    if (all(lapply(args.simplified, is.numeric))) {
      as.numeric(args.simplified)
    } else {
      for (i in 1:length(args)) {
        expr[[i + 1]] <- args.simplified[[i]]
      }
      expr
    }
  }


  assign("+", `Simplify.+`, envir = yuima.env)
  assign("-", `Simplify.-`, envir = yuima.env)
  assign("*", `Simplify.*`, envir = yuima.env)
  assign("(", `Simplify.(`, envir = yuima.env)
  assign("c", `Simplify.c`, envir = yuima.env)
  assign("^", `Simplify.^`, envir = yuima.env)


  ###








  as.expression(Simplify_(expr[[1]]))
}


## Constructor and Initializer of class 'yuima'

# we convert objects to "zoo" internally
# we should change it later to more flexible classes

setMethod(
  "initialize", "yuima",
  function(.Object, data = NULL, model = NULL, sampling = NULL, characteristic = NULL, functional = NULL) {
    eqn <- NULL

    if (!is.null(data)) {
      .Object@data <- data
      eqn <- dim(data)
      if (is.null(sampling)) {
        sampling <- setSampling(grid = list(index(get.zoo.data(data)[[1]])))
      }
    }

    if (!is.null(model)) {
      if (!is.null(eqn)) {
        if (eqn != model@equation.number) {
          yuima.warn("Model's equation number missmatch.")
          return(NULL)
        }
      } else {
        eqn <- model@equation.number
      }
      .Object@model <- model
    }

    if (!is.null(sampling)) {
      if (!is.null(eqn)) {
        if (eqn != length(sampling@Terminal)) {
          if (length(sampling@Terminal) == 1) {
            sampling@Terminal <- rep(sampling@Terminal, eqn)
            sampling@n <- rep(sampling@n, eqn)
          } else {
            yuima.warn("Sampling's equation number missmatch.")
            return(NULL)
          }
        }
      } else {
        eqn <- length(sampling@Terminal)
      }
      .Object@sampling <- sampling
    }

    if (!is.null(characteristic)) {
      if (!is.null(eqn)) {
        if (eqn != characteristic@equation.number) {
          yuima.warn("Characteristic's equation number missmatch.")
          return(NULL)
        }
      }
      .Object@characteristic <- characteristic
    } else if (!is.null(eqn)) {
      characteristic <- new("yuima.characteristic", equation.number = eqn, time.scale = 1)
      .Object@characteristic <- characteristic
    }

    if (!is.null(functional)) .Object@functional <- functional

    return(.Object)
  }
)

# setter
setYuima <-
  function(data = NULL, model = NULL, sampling = NULL, characteristic = NULL, functional = NULL, variable_data_mapping = NULL) {
    if (is.CarmaHawkes(model) && !is.null(data)) {
      if (is(data, "zoo")) {
        data <- setData(original.data = data, t0 = index(data)[1])
      }
      if (is.null(sampling)) {
        zooData <- get.zoo.data(data)[[1]]
        originalgrid <- index(zooData)
        samp <- setSampling(Initial = originalgrid[1], Terminal = tail(originalgrid, 1L), n = as.integer((tail(originalgrid, 1L) - originalgrid[1]) / mean(diff(originalgrid))))
        gridData <- na.approx(zooData, xout = samp@grid[[1]])
        model@solve.variable <- model@info@Counting.Process
        data@zoo.data[[1]] <- gridData
        res <- new("yuima", data = NULL, model = model, sampling = NULL, characteristic = characteristic, functional = functional)
        res@data <- data
        res@sampling <- samp
      } else {
        zooData <- get.zoo.data(data)
        samp <- sampling
        gridData <- na.approx(zooData, xout = samp@grid[[1]])
        model@solve.variable <- model@info@Counting.Process
        data@zoo.data[[1]] <- gridData
        res <- new("yuima", data = NULL, model = model, sampling = NULL, characteristic = characteristic, functional = functional)
        res@data <- data
        res@sampling <- samp
      }
      return(res)
    }
    if (is.CARMA(model) && !is.null(data)) {
      if (dim(data@original.data)[2] == 1) {
        dum.matr <- matrix(
          0, length(data@original.data),
          (model@info@p + 1)
        )
        dum.matr[, 1] <- as.numeric(data@original.data)
        data <- setData(zoo(x = dum.matr, order.by = time(data@zoo.data[[1]])))
      }
    }
    if (is.COGARCH(model) && !is.null(data)) {
      if (dim(data@original.data)[2] == 1) {
        #         data<-setData(zoo(x=matrix(as.numeric(data@original.data),length(data@original.data),
        #                                    (model@info@p+1)), order.by=time(data@zoo.data[[1]])))
        dum.matr <- matrix(
          0, length(data@original.data),
          (model@info@q + 2)
        )
        dum.matr[, 1] <- as.numeric(data@original.data)
        data <- setData(zoo(x = dum.matr, order.by = time(data@zoo.data[[1]])))
      }
    }

    if (!is.null(variable_data_mapping) && !is.null(data)) {
      if (!all(is.na(variable_data_mapping[duplicated(variable_data_mapping)]))) {
        yuima.stop("Invalid list for 'variable_data_mapping'. some values are duplicated.")
      }
      original.data <- data
      new.data <- NULL
      for (variable in model@state.variable) {
        if (is.null(variable_data_mapping[[variable]]) || is.na(variable_data_mapping[[variable]])) {
          if (is.null(new.data)) {
            new.data <- matrix(NA, nrow = length(data@zoo.data[[1]]))
          } else {
            new.data <- cbind(new.data, NA)
          }
        } else {
          column_num <- as.numeric(variable_data_mapping[variable])
          if (is.null(new.data)) {
            new.data <- matrix(original.data@zoo.data[[column_num]])
          } else {
            new.data <- cbind(new.data, matrix(original.data@zoo.data[[column_num]]))
          }
        }
      }
      colnames(new.data) <- paste("Series", 1:length(model@state.variable))
      data <- setData(zoo(x = new.data, order.by = time(data@zoo.data[[1]])))
    }

    # LM 25/04/15
    return(new("yuima", data = data, model = model, sampling = sampling, characteristic = characteristic, functional = functional))
  }




setMethod(
  "show", "yuima.functional",
  function(object) {
    str(object)
  }
)

setMethod(
  "show", "yuima.sampling",
  function(object) {
    str(object)
  }
)


setMethod(
  "show", "yuima.data",
  function(object) {
    show(setYuima(data = object))
  }
)


setMethod(
  "show", "yuima.model",
  function(object) {
    show(setYuima(model = object))
  }
)

setMethod(
  "show", "yuima",
  function(object) {
    myenv <- new.env()
    mod <- object@model
    has.drift <- FALSE
    has.diff <- FALSE
    has.fbm <- FALSE
    has.levy <- FALSE
    is.wienerdiff <- FALSE
    is.fracdiff <- FALSE
    is.jumpdiff <- FALSE
    is.carma <- FALSE
    is.cogarch <- FALSE
    is.poisson <- is.Poisson(mod)

    if (length(mod@drift) > 0 & !all(as.character(mod@drift) %in% c("(0)", "expression((0))"))) {
      has.drift <- TRUE
    }
    if (length(mod@diffusion) > 0 & !all(as.character(mod@diffusion) %in% c("(0)", "expression((0))"))) {
      has.diff <- TRUE
    }
    if (length(mod@jump.coeff) > 0) {
      has.levy <- TRUE
    }

    if (!is.null(mod@hurst)) {
      if (!is.na(mod@hurst)) {
        if (mod@hurst != 0.5) {
          has.fbm <- TRUE
        }
      }
    }
    if (has.diff) is.wienerdiff <- TRUE
    # if( has.drift | has.diff ) is.wienerdiff <- TRUE
    if (has.fbm) is.fracdiff <- TRUE
    if (has.levy) is.jumpdiff <- TRUE
    ldif <- 0
    if (length(mod@diffusion) > 0) {
      ldif <- length(mod@diffusion[[1]])
    }
    if (ldif == 1 & (length(mod@diffusion) == 0)) {
      if (as.character(mod@diffusion[[1]]) %in% c("(0)", "expression(0)")) {
        has.diff <- FALSE
        is.wienerdiff <- FALSE
        is.fracdiff <- FALSE
      }
    }
    # if( class(mod) == "yuima.carma")
    if (inherits(mod, "yuima.carma")) { # YK, Mar. 22, 2022
      is.carma <- TRUE
    }
    # if( class(mod) == "yuima.cogarch"){
    if (inherits(mod, "yuima.cogarch")) { # YK, Mar. 22, 2022
      is.cogarch <- TRUE
      is.wienerdiff <- FALSE
      is.fracdiff <- FALSE
    }

    if (is.wienerdiff | is.fracdiff | is.jumpdiff) {
      if (is.wienerdiff & !is.carma & !is.poisson & !is.cogarch) {
        cat("\nDiffusion process")
        if (!has.drift) cat(", driftless")
        if (is.fracdiff) {
          if (!is.na(mod@hurst)) {
            if (mod@hurst != 0.5) {
              cat(sprintf(" with Hurst index:%.2f", mod@hurst))
            }
          } else {
            cat(" with unknown Hurst index")
          }
        }
      }
      if (is.carma) {
        cat(sprintf("\nCarma process p=%d, q=%d", mod@info@p, mod@info@q))
      }
      if (is.cogarch) {
        cat(sprintf("\nCogarch process p=%d, q=%d", mod@info@p, mod@info@q))
      }
      if (is.poisson) {
        cat("\nCompound Poisson process")
      }

      if ((is.jumpdiff & !is.cogarch)) {
        if ((is.wienerdiff | is.carma) & !is.poisson) {
          cat(" with Levy jumps")
        } else {
          if (!is.poisson) {
            cat("Levy process")
          }
        }
      } else {
        if (is.jumpdiff) {
          cat(" with Levy jumps")
        }
      }

      cat(sprintf("\nNumber of equations: %d", mod@equation.number))
      if ((is.wienerdiff | is.fracdiff) & !is.poisson) {
        cat(sprintf("\nNumber of Wiener noises: %d", mod@noise.number))
      }
      if (is.jumpdiff & !is.poisson) {
        cat(sprintf("\nNumber of Levy noises: %d", 1))
      }
      if (is.cogarch) {
        cat(sprintf("\nNumber of quadratic variation: %d", 1))
      }
      if (length(mod@parameter@all) > 0) {
        cat(sprintf("\nParametric model with %d parameters", length(mod@parameter@all)))
      }
    }

    if (length(object@data@original.data) > 0) {
      n.series <- 1
      if (!is.null(dim(object@data@original.data))) {
        n.series <- dim(object@data@original.data)[2]
        n.length <- dim(object@data@original.data)[1]
      } else {
        n.length <- length(object@data@original.data)
      }

      cat(sprintf("\n\nNumber of original time series: %d\nlength = %d, time range [%s ; %s]", n.series, n.length, min(time(object@data@original.data)), max(time(object@data@original.data))))
    }
    if (length(object@data@zoo.data) > 0) {
      n.series <- length(object@data@zoo.data)
      n.length <- unlist(lapply(object@data@zoo.data, length))
      t.min <- unlist(lapply(object@data@zoo.data, function(u) as.character(round(time(u)[which.min(time(u))], 3))))
      t.max <- unlist(lapply(object@data@zoo.data, function(u) as.character(round(time(u)[which.max(time(u))], 3))))

      delta <- NULL
      is.max.delta <- rep("", n.series)
      have.max.delta <- FALSE
      for (i in 1:n.series) {
        tmp <- length(table(round(diff(time(object@data@zoo.data[[i]])), 5)))
        if (tmp > 1) {
          tmp <- max(diff(time(object@data@zoo.data[[i]])), na.rm = TRUE)
          is.max.delta[i] <- "*"
          have.max.delta <- TRUE
          # tmp <- NULL
        } else {
          tmp <- diff(time(object@data@zoo.data[[i]]))[1]
        }
        if (is.null(tmp)) {
          delta <- c(delta, NA)
        } else {
          delta <- c(delta, tmp)
        }
      }


      cat(sprintf("\n\nNumber of zoo time series: %d\n", n.series))
      tmp <- data.frame(length = n.length, time.min = t.min, time.max = t.max, delta = delta)
      if (have.max.delta) {
        tmp <- data.frame(tmp, note = is.max.delta)
      }
      nm <- names(object@data@zoo.data)
      if (is.null(nm)) {
        rownames(tmp) <- sprintf("Series %d", 1:n.series)
      } else {
        rownames(tmp) <- nm
      }
      print(tmp)
      if (have.max.delta) {
        cat("================\n* : maximal mesh")
      }
    }
  }
)
