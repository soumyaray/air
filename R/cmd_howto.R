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
  creds <- validated_credentials_or_stop()

  context <- paste(
    "I want you to act as an R programming expert.",
    "I want you to answer only with code, without triple backtics.",
    "Do not write explanations.")

  code <- api_answer_or_stop(do, creds, context, call_api)

  message(paste0(code, "\n"))
  invisible(code)
}
