# Acts as a simple Result monad for R
result <- function(success = TRUE, status = "ok", message = "done") {
  obj <- list(success = success, status = status, message = message)
  class(obj) <- c("result", class(obj))
  obj
}

# Makes calling function to return with a Result
return_with <- function(success = TRUE, status = "ok", message = "done"){
  res <- result(success = success, status = status, message = message)
  do.call(return, list(res), envir = sys.frame(-1))
}
