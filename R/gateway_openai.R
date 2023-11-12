parse_response_message <- function(json_body) {
  res_obj <- rjson::fromJSON(json_body)
  res_obj$choices[[1]]$message$content
}

ai_completion_request <- function(do, model) {
  endpoint <- "https://api.openai.com/v1/chat/completions"

  messages <- list(
    list(role = "system",
         content = paste(
           "I want you to act as an R programming expert.",
           "I want you to answer only with code, without triple backtics.",
           "Do not write explanations.")),
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

  res <- httr::POST(
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
