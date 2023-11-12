#' Securely stores your your OpenAI API key to your OS keyring.
#'
#' @param key Optional string of your OpenAI API key;
#'            if not provided, a popup will ask you to enter it (safer).
#'
#' @examples
#' set_key("sk-my-api-key")
#' set_key()
#'
#' @export
set_key <- function(key = NULL) {
  res <- set_secret("openai-key", key)
  if (res$success) {
    message("Your key is securely set!")
  } else {
    message("Error setting your key: please submit an issue with details")
  }
}

#' Securely stores your your OpenAI API key to your OS keyring.
#'
#' @param model String of your preferred model; defaults to 'gpt-4'.
#'
#' @examples
#' set_model("gpt-4-1106-preview")
#' set_model() # use default
#'
#' @export
set_model <- function(model = "gpt-4") {
  res <- set_secret("openai-model", model)
  if (res$success) {
    message(paste0("Your preferred model is now ", model, "."))
  } else {
    message("Error setting your model: please submit an issue with details")
  }
}

#' Deletes your securely stored OpenAI API key from your OS keyring.
#'
#' @examples
#' delete_key()
#'
#' @export
delete_key <- function() {
  res <- delete_secret("openai-key")
  message(res$message)
}

#' Deletes your stored OpenAI API model from your OS keyring.
#'
#' @examples
#' delete_model()
#'
#' @export
delete_model <- function() {
  res <- delete_secret("openai-model")
  message(res$message)
}

get_secret <- function(secret) {
  tryCatch(
    expr = {
      value <- keyring::key_get(service = "air-rpkg", username = secret)
      result(TRUE, "success", value)
    },
    error = function(cond) {
      result(FALSE, "error", cond)
    },
    warning = function(cond) {
      result(TRUE, "warn", value)
    }
  )
}

get_secret_or_return <- function(secret) {
  res <- get_secret(secret)
  ifelse(
    res$success,
    res$message,
    return_with(paste0("The secret credential '", secret, "' is not yet set.")))
}

set_secret <- function(secret, value = NULL) {
  tryCatch(
    if (is.null(value)) {
      keyring::key_set(service = "air-rpkg", username = secret)
      result(TRUE, "success", secret)
    } else {
      keyring::key_set_with_value(
        service = "air-rpkg",
        username = secret,
        password = value)
      result(TRUE, "success", secret)
    },
    error = function(cond) {
      message(paste0(
        "Error trying to set your secure ", secret, ":\n", cond
      ))
      result(FALSE, "error", cond)
    },
    warning = function(cond) {
      message(paste0(
        "Warning while trying to set your secure ", secret, ":\n", cond
      ))
      result(TRUE, "warn", cond)
    }
  )
}

delete_secret <- function(secret) {
  tryCatch(
    expr = {
      keyring::key_delete(service = "air-rpkg", username = secret)
      result(TRUE, "deleted", paste0("Deleted ", secret))
    },
    error = function(cond) {
      result(FALSE, "error", cond)
    },
    warning = function(cond) {
      result(TRUE, "warn", cond)
    }
  )
}
