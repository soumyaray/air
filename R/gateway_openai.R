ai_completion_request <- function(do, model, context) {
  endpoint <- "https://api.openai.com/v1/chat/completions"

  messages <- list(
    list(role = "system", content = context),
    list(role = "user", content = do)
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

  tryCatch(
    expr = {
      res <- httr::POST(
        url = endpoint,
        httr::add_headers(
          `Content-Type` = "application/json",
          Authorization = paste0("Bearer ", key)
        ),
        body = json_body
      )

      successful <- httr::http_status(res)$category == "Success"
      msg <- ifelse(successful,
        rawToChar(res$content),
        parse_response_error(rawToChar(res$content)))

      result(
        successful = successful,
        status = httr::http_status(res)$message,
        value = msg
      )
    },
    error = \(cond) {
      failure(status = "Connection Error", value = cond)
    }
  )
}

parse_response_message <- function(json_body) {
  res_obj <- rjson::fromJSON(json_body)
  res_obj$choices[[1]]$message$content
}

parse_response_error <- function(json_body) {
  res_obj <- rjson::fromJSON(json_body)
  res_obj$error$message
}
