# Gets your OpenAI API key credential.
#
# Searches for your OpenAI API key in the following order:
# 1. Environment variable `OPENAI_KEY` – can be set in your `.Renviron` file
# 2. OS keyring – can be set securely with `set_key()`
get_key <- function() {
  get_credential("OPENAI_KEY")
}

# Gets your OpenAI API model preference.
#
# Searches for your OpenAI API model preference in the following order:
# 1. Environment variable `OPENAI_MODEL` – can be set in your `.Renviron` file
# 2. OS keyring – can be set securely with `set_model()`
get_model <- function() {
  get_credential("OPENAI_MODEL")
}

#' Securely stores your your OpenAI API key to your OS keyring.
#'
#' @param key Optional string of your OpenAI API key;
#'            if not provided, a popup will ask you to enter it (safer).
#'
#' @return No return value; only side-effect and message printed to console
#'
#' @examples
#' # CAREFUL: Changes your OpenAI API key in your OS keyring
#' \dontrun{
#' set_key("sk-my-api-key") # sets the key directly (will show in .Rhistory)
#' set_key()                # opens a system popup for secure entry
#' }
#'
#' @export
set_key <- function(key = NULL) {
  res <- set_keyring_secret("OPENAI_KEY", key)
  if (result::is_success(res)) {
    message("Your key is securely set!")
  } else {
    message("Error setting your key: please submit an issue with details")
  }
}

#' Securely stores your your OpenAI API key to your OS keyring.
#'
#' @param model String of your preferred model; defaults to 'gpt-4'.
#'
#' @return No return value; only side-effect and message printed to console
#'
#' @examples
#' # CAREFUL: Changes your OpenAI API model in your OS keyring
#' \dontrun{
#' set_model("gpt-4-1106-preview")
#' set_model() # use default
#' }
#'
#' @export
set_model <- function(model = "gpt-4") {
  res <- set_keyring_secret("OPENAI_MODEL", model)
  if (result::is_success(res)) {
    message(paste0("Your preferred model is now ", model, "."))
  } else {
    message("Error setting your model: please submit an issue with details")
  }
}

#' Deletes your securely stored OpenAI API key and preferred model
#' from your OS keyring.
#'
#' @return \code{result} list of \code{success} or \code{failure} class with:
#' \item{status}{A character string of operation status.}
#' \item{value}{A character string of descriptive message of status.}
#'
#' @examples
#' # CAREFUL: Deletes OpenAI API key and preferred model from your OS keyring
#' \dontrun{
#' delete_keyring_credentials()
#' }
#'
#' @export
delete_keyring_credentials <- function() {
  tryCatch(
    expr = {
      keyring::key_delete("air-rpkg")
      result::success(value = "Credentials deleted", status = "success")
    },
    error = \(cond) {
      result::failure(value = "No credentials to delete", status = "error")
    }
  )
}

# Gets a secret credential from your keyring or env variables.
# It first checks the environment variables, then the keyring.
get_credential <- function(secret) {
  res <- get_env_secret(secret)
  if (result::is_failure(res)) {
    res <- get_keyring_secret(secret)
  }

  res
}

get_env_secret <- function(secret) {
  value <- Sys.getenv(secret)
  if (value == "") {
    result::failure(paste0("No ", secret, " found."), "notfound")
  } else {
    result::success(value, "success")
  }
}

get_keyring_secret <- function(secret) {
  value <- NULL
  warned <- FALSE
  tryCatch({
    withCallingHandlers(
      expr = {
        value <<- keyring::key_get(service = "air-rpkg", username = secret)
      },
      warning = function(cond) warned <<- TRUE
    )
    if (!warned) {
      result::success("success", value)
    } else {
      result::success("warning", value)
    }
  }, error = function(cond) {
    result::failure("error", cond)
  })
}

set_keyring_secret <- function(secret, value = NULL) {
  tryCatch(
    if (is.null(value)) {
      keyring::key_set(service = "air-rpkg", username = secret)
      result::success("set", secret)
    } else {
      keyring::key_set_with_value(
        service = "air-rpkg",
        username = secret,
        password = value)
      result::success(secret, "set")
    },
    error = function(cond) {
      message(paste0(
        "Error trying to set your secure ", secret, ":\n", cond
      ))
      result::failure(cond, "error")
    },
    warning = function(cond) {
      message(paste0(
        "Warning while trying to set your secure ", secret, ":\n", cond
      ))
      result::success(cond, "warning")
    }
  )
}
