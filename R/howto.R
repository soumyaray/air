#' Ask OpenAI to write R code for a problem.
#' The answer is written to console and returned as a string.
#'
#' @param do Character string of what you want to do
#' @param call_api Optional function to call another API
#' @return Invisible character string of R code
#'
#' @examples
#' howto("read a csv file")
#' howto("get last element of a vector")
#'
#' @export
howto <- function(do, call_api = call_openai) {
  key_res <- get_key()
  model_res <- get_model()

  if (!key_res$success || !model_res$success) {
    stop(paste("Please set your OpenAI key and model first.\n",
               "See package documentation for details."))
  }

  key <- key_res$message
  model <- model_res$message

  req <- ai_completion_request(do, model)
  res <- call_api(req$endpoint, key, req$json_body)

  if (!res$success) {
    stop(res$message)
  }

  code <- parse_response_message(res$message)

  message(paste0(code, "\n"))
  invisible(code)
}
