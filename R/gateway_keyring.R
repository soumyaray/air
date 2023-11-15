#' Gets your OpenAI API key credential.
#'
#' Searches for your OpenAI API key in the following order:
#' 1. Environment variable `OPENAI_KEY` – can be set in your `.Renviron` file
#' 2. OS keyring – can be set securely with `set_key()`
#'
get_key <- function() {
  get_credential("OPENAI_KEY")
}

#' Gets your OpenAI API model preference.
#'
#' Searches for your OpenAI API model preference in the following order:
#' 1. Environment variable `OPENAI_MODEL` – can be set in your `.Renviron` file
#' 2. OS keyring – can be set securely with `set_model()`
#'
get_model <- function() {
  get_credential("OPENAI_MODEL")
}

#' Securely stores your your OpenAI API key to your OS keyring.
#'
#' @param key Optional string of your OpenAI API key;
#'            if not provided, a popup will ask you to enter it (safer).
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
  if (is_success(res)) {
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
#' # CAREFUL: Changes your OpenAI API model in your OS keyring
#' \dontrun{
#' set_model("gpt-4-1106-preview")
#' set_model() # use default
#' }
#'
#' @export
set_model <- function(model = "gpt-4") {
  res <- set_keyring_secret("OPENAI_MODEL", model)
  if (is_success(res)) {
    message(paste0("Your preferred model is now ", model, "."))
  } else {
    message("Error setting your model: please submit an issue with details")
  }
}

#' Deletes your securely stored OpenAI API key and preferred model
#' from your OS keyring.
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
      success(status = "success", value = "Credentials deleted")
    },
    error = \(cond) {
      failure(status = "error", value = "No credentials to delete")
    }
  )
}

# Gets a secret credential from your keyring or env variables.
# It first checks the environment variables, then the keyring.
get_credential <- function(secret) {
  res <- get_env_secret(secret)
  if (!is_success(res)) {
    res <- get_keyring_secret(secret)
  }

  return(res)
}

get_env_secret <- function(secret) {
  value <- Sys.getenv(secret)
  if (value == "") {
    failure("notfound", paste0("No ", secret, " found."))
  } else {
    success("success", value)
  }
}

get_keyring_secret <- function(secret) {
  tryCatch(
    expr = {
      value <- keyring::key_get(service = "air-rpkg", username = secret)
      success("success", value)
    },
    error = function(cond) {
      failure("error", cond)
    },
    warning = function(cond) {
      success("warn", value)
    }
  )
}

set_keyring_secret <- function(secret, value = NULL) {
  tryCatch(
    if (is.null(value)) {
      keyring::key_set(service = "air-rpkg", username = secret)
      success("set", secret)
    } else {
      keyring::key_set_with_value(
        service = "air-rpkg",
        username = secret,
        password = value)
      success("set", secret)
    },
    error = function(cond) {
      message(paste0(
        "Error trying to set your secure ", secret, ":\n", cond
      ))
      failure("error", cond)
    },
    warning = function(cond) {
      message(paste0(
        "Warning while trying to set your secure ", secret, ":\n", cond
      ))
      success("warning", cond)
    }
  )
}
