#' @export
howto <- function(do, call_api = call_openai) {
  key <- get_secret_or_return("openai-key")
  model <- get_secret_or_return("openai-model")

  req <- ai_completion_request(do, model)
  res <- call_api(req$endpoint, key, req$json_body)

  code <- parse_response_message(res$message)

  cat(paste0(code, "\n"))
  invisible(code)
}

parse_response_message <- function(json_body) {
  res_obj <- rjson::fromJSON(json_body)
  res_obj$choices[[1]]$message$content
}

ai_completion_request <- function(do, model) {
  endpoint <- "https://api.openai.com/v1/chat/completions"

  messages <- list(
    list(role = "system", content = paste(
      "I want you to act as an R programming expert.",
      "I want you to answer only with code, without triple backtics.",
      "Do not write explanations.")),
    list(role = "user", content=do)
  )

  json_body <- rjson::toJSON(list(
    model = model,
    messages = messages
  ))

  list(endpoint = endpoint, json_body = json_body)
}

call_openai <- function(endpoint, key, json_body) {
  ## TODO: Switch to httr2 instead of httr once vcr support available:
  ## VCR issue: https://github.com/ropensci/vcr/issues/237
  # res = httr2::request(endpoint) |>
  #   httr2::req_auth_bearer_token(key) |>
  #   httr2::req_headers("Content-Type" = "application/json") |>
  #   httr2::req_body_raw(json_body) |>
  #   # httr2::req_error(is_error = function(resp) FALSE) |>
  #   httr2::req_perform()
  #   # httr2::req_dry_run()

  res = httr::POST(
    url = endpoint,
    httr::add_headers(
      `Content-Type` = "application/json",
      Authorization = paste0("Bearer ", key)
    ),
    body = json_body
  )

  result(
    success = httr::http_status(res)$category == "Success",
    status = httr::http_status(res)$message,
    message = rawToChar(res$content)
  )
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

## Useful for stubbing call_api:
# list_a <- list(item1 = list(attr1 = "A", attr2 = "B"),
#                item2 = list(attr1 = "C", attr2 = "D"),
#                item3 = list(attr1 = "A", attr2 = "B"))

# vector_b <- c("A", "B")
# names(vector_b) <- c("attr1", "attr2")

# matching_element <- sapply(list_a, function(item) {
#   all(unname(sapply(names(vector_b), function(attr) item[[attr]] == vector_b[[attr]])))
# })

# matching_element <- names(which(matching_element))

## Making secret/hidden parameteres to a function
# make_function <- function(x, y, ...) {
#   # Hidden parameters
#   hidden_params <- list(...)
#
#   # Discouraging message
#   if (!is.null(hidden_params)) {
#     message("Warning: Use of hidden parameters is discouraged.")
#   }
#
#   # Function's main code
#   # (Example operation using x and y)
#   result <- x + y
#
#   # Possibly use hidden parameters
#   #...
#
#   return(result)
# }
