# foo <- function() crul::ok('https://httpbin.org/get')

test_that("HAPPY: howto works", {
  vcr::use_cassette("open-ai", {
    good <- air::howto("How do I get the first element of a list?")
  })
  expect_true(class(good) == "character")
})
