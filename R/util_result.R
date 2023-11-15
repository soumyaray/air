# Acts as a  Result monad for R – all parameters must be specified
result <- function(success, status, value) {
  result_type <- ifelse(success, "success", "failure")
  obj <- list(success = success, status = status, value = value)
  class(obj) <- c(result_type, "result", class(obj))
  obj
}

#' make s3 print function for result, which prints its value
#' @export
print.result <- function(x, ...) {
  print(x$value)
}

# Acts as a sucess Result monad for R
success <- function(status = "ok", value = "done") {
  result(success = TRUE, status = status, value = value)
}

failure <- function(status = "error", value = "failed") {
  result(success = FALSE, status = status, value = value)
}

# Makes calling function to return with a Result
return_with <- function(success = TRUE, status = "ok", value = "done") {
  res <- result(success = success, status = status, value = value)
  do.call(return, list(res), envir = sys.frame(-1))
}

is_success <- function(obj) {
  UseMethod("is_success", obj)
}

is_failure <- function(obj) {
  UseMethod("is_failure", obj)
}

value <- function(obj) {
  UseMethod("value", obj)
}

is_success.result <- function(obj) {
  obj$success
}

is_failure.result <- function(obj) {
  !is_success(obj)
}

value.result <- function(obj) {
  obj$value
}
