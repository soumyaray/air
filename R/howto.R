# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Install Package:           'Cmd + Shift + B'
#   Check Package:             'Cmd + Shift + E'
#   Test Package:              'Cmd + Shift + T'

howto <- function(do) {
  key <- get_secret_or_return("openai-key")
  model <- get_secret_or_return("openai-model")

  endpoint <- "https://api.openai.com/v1/chat/completions"
  auth <- paste("Bearer", key)
  messages <- list(
    list(role = "system", content = paste(
      "I want you to act as an R programming expert.",
      "I want you to answer only with code, without triple backtics.",
      "Do not write explanations.")),
    list(role = "user", content=do)
  )

  json_body <- rjson::toJSON(list(
    model = "gpt-4-1106-preview",
    messages = messages
  ))

  res = httr2::request(endpoint) |>
    httr2::req_auth_bearer_token(key) |>
    httr2::req_headers("Content-Type" = "application/json") |>
    httr2::req_body_raw(json_body) |>
    # httr2::req_error(is_error = function(resp) FALSE) |>
    httr2::req_perform()
    # httr2::req_dry_run()

  res_obj <- rjson::fromJSON(rawToChar(res$body))
  code <- res_obj$choices[[1]]$message$content
  cat(paste0(code))
  invisible(code)
}

result <- function(success = TRUE, status = "ok", message = "done") {
  list(success = success, status = status, message = message)
}

return_with <- function(success = TRUE, status = "ok", message = "done"){
  res <- result(success = success, status = status, message = message)
  do.call(return, list(res), envir = sys.frame(-1))
}

set_key <- function(key = NULL) {
  res <- set_secret("openai-key", key)
  ifelse(
    res$success,
    message("Your key is securely set!"),
    message("Error setting your key: please submit an issue with details")
  )
}

set_model <- function(model = NULL) {
  res <- set_secret("openai-model", model)
  ifelse(
    res$success,
    message("Your preferred model is securely set!"),
    message("Error setting your model: please submit an issue with details")
  )
}

delete_key <- function() {
  res <- delete_secret("openai-key")
  ifelse(
    res$success,
    message("Your secure key is deleted!"),
    message("Error deleting your key: please submit an issue with details")
  )
}

delete_model <- function() {
  res <- delete_secret("openai-model")
  ifelse(
    res$success,
    message("Your secure model is deleted!"),
    message("Error deleting your model: please submit an issue with details")
  )
}

get_secret <- function(secret) {
  tryCatch(
    value <- keyring::key_get(service = "air-rpkg", username = secret),
    error = function(cond) {
      return(result(FALSE, "error", cond))
    },
    warning = function(cond) {
      return(result(TRUE, "warn", value))
    }
  )
  return(result(TRUE, "success", value))
}

get_secret_or_return <- function(secret) {
  res <- get_secret(secret)
  ifelse(
    res$success,
    res$message,
    return_with(paste0("The secret credential '", secret, "' is not yet set.")))
}

set_secret <- function(secret, value) {
  tryCatch(
    if (is.null(value)) {
      keyring::key_set(service = "air-rpkg", username = secret)
    } else {
      keyring::key_set_with_value(
        service = "air-rpkg",
        username = secret,
        password = value)
    },
    error = function(cond) {
      message(paste0(
        "Error trying to set your secure ", secret, ":\n", cond
      ))
      return(result(FALSE, "error", cond))
    },
    warning = function(cond) {
      message(paste0(
        "Warning while trying to set your secure ", secret, ":\n", cond
      ))
      return(result(TRUE, "warn", cond))
    }
  )
  result(TRUE, "success", secret)
}

delete_secret <- function(secret) {
  tryCatch(
    keyring::key_delete(service = "air-rpkg", username = secret),
    error = function(cond) {
      message(paste0(
        "Error trying to delete your secure ", secret, ":\n", cond
      ))
      return(result(FALSE, "error", cond))
    },
    warning = function(cond) {
      message(paste0(
        "Warning while trying to delete your secure ", secret, ":\n", cond
      ))
      return(result(TRUE, "warn", cond))
    }
  )
}
