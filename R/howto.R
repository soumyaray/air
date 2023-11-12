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

  if (failure(key_res) || failure(model_res)) {
    stop(paste("Please set your OpenAI key and model first.\n",
               "See package documentation for details."))
  }

  key <- value(key_res)
  model <- value(model_res)

  req <- ai_completion_request(do, model)
  res <- call_api(req$endpoint, key, req$json_body)

  if (failure(res)) {
    stop(value(res))
  }

  code <- parse_response_message(value(res))

  message(paste0(code, "\n"))
  invisible(code)
}
