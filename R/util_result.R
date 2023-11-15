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

is_success <- function(obj) UseMethod("is_success", obj)
is_failure <- function(obj) UseMethod("is_failure", obj)
value <- function(obj) UseMethod("value", obj)
status <- function(obj) UseMethod("status", obj)

is_success.success <- function(obj) TRUE
is_success.failure <- function(obj) FALSE
is_failure.result <- function(obj) !is_success(obj)

status.result <- function(obj) obj$status
value.result <- function(obj) obj$value
