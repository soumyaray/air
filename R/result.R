# Acts as a simple Result monad for R
result <- function(success = TRUE, status = "ok", value = "done") {
  obj <- list(success = success, status = status, value = value)
  class(obj) <- c("result", class(obj))
  obj
}

# Makes calling function to return with a Result
return_with <- function(success = TRUE, status = "ok", value = "done"){
  res <- result(success = success, status = status, value = value)
  do.call(return, list(res), envir = sys.frame(-1))
}

success <- function(obj) {
  UseMethod("success", obj)
}

failure <- function(obj) {
  UseMethod("failure", obj)
}

value <- function(obj) {
  UseMethod("value", obj)
}

success.result <- function(obj) {
  obj$success
}

failure.result <- function(obj) {
  !success(obj)
}

value.result <- function(obj) {
  obj$value
}
