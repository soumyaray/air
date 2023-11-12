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
